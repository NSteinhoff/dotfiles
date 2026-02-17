import { tool } from "@opencode-ai/plugin";

const DESCRIPTION = [
	"Read-only repository inspection tool.",
	"Use this to review local pending changes and local commits without running git directly.",
	"This tool replaces direct use of git status, git diff, git log, and git show for coding-agent workflows.",
	"Only non-destructive local inspection commands are executed.",
];

const ALLOWED_VIEWS = new Set(["overview", "diff", "log", "show"]);

type GitResult = {
	stdout: string;
	stderr: string;
	exitCode: number;
};

export default tool({
	description: DESCRIPTION.join(" "),
	args: {
		view: tool.schema
			.string()
			.optional()
			.describe(
				[
					"Inspection view to render.",
					"Supported values: overview, diff, log, show.",
					"Default: overview.",
				].join(" "),
			),
		rev: tool.schema
			.string()
			.optional()
			.describe("Revision to inspect for view=show (default: HEAD)."),
		base: tool.schema
			.string()
			.optional()
			.describe("Base revision for view=diff range mode."),
		head: tool.schema
			.string()
			.optional()
			.describe("Head revision for view=diff range mode."),
		path: tool.schema
			.string()
			.optional()
			.describe("Optional path filter for status/diff/log/show."),
		max_commits: tool.schema
			.number()
			.int()
			.min(1)
			.max(200)
			.optional()
			.describe("Maximum number of commits for view=overview or view=log."),
		max_patch_lines: tool.schema
			.number()
			.int()
			.min(50)
			.max(5000)
			.optional()
			.describe("Maximum number of diff/show patch lines to return."),
	},
	async execute(args, context) {
		const worktree = context.worktree;
		const view = args.view?.trim().toLowerCase() || "overview";
		const maxCommits = clampInt(args.max_commits, 20, 1, 200);
		const maxPatchLines = clampInt(args.max_patch_lines, 400, 50, 5000);

		if (!ALLOWED_VIEWS.has(view)) {
			return `Unsupported view '${view}'. Supported views: overview, diff, log, show.`;
		}

		const validationError = validateRefInputs({
			rev: args.rev,
			base: args.base,
			head: args.head,
		});
		if (validationError) return validationError;

		const repoCheck = await runGit(["rev-parse", "--is-inside-work-tree"], worktree);
		if (repoCheck.exitCode !== 0 || repoCheck.stdout.trim() !== "true") {
			return "Not a git repository in the current worktree.";
		}

		await context.ask({
			permission: "status",
			patterns: [
				view,
				args.rev?.trim() || "",
				args.base?.trim() || "",
				args.head?.trim() || "",
				args.path?.trim() || "",
			].filter((item) => item.length > 0),
			always: ["*"],
			metadata: {
				view,
				worktree,
				mode: `status-${view}`,
				rev: args.rev?.trim() || undefined,
				base: args.base?.trim() || undefined,
				head: args.head?.trim() || undefined,
				path: args.path?.trim() || undefined,
				maxCommits,
				maxPatchLines,
			},
		});

		if (view === "overview") {
			return renderOverview({ worktree, path: args.path?.trim(), maxCommits });
		}

		if (view === "diff") {
			return renderDiff({
				worktree,
				base: args.base?.trim(),
				head: args.head?.trim(),
				path: args.path?.trim(),
				maxPatchLines,
			});
		}

		if (view === "log") {
			return renderLog({
				worktree,
				path: args.path?.trim(),
				maxCommits,
			});
		}

		return renderShow({
			worktree,
			rev: args.rev?.trim() || "HEAD",
			path: args.path?.trim(),
			maxPatchLines,
		});
	},
});

async function renderOverview(input: {
	worktree: string;
	path?: string;
	maxCommits: number;
}): Promise<string> {
	const statusArgs = ["status", "--short", "--untracked-files=all"];
	if (input.path) statusArgs.push("--", input.path);

	const [statusRes, logRes] = await Promise.all([
		runGit(statusArgs, input.worktree),
		runGit(
			[
				"log",
				`-n${input.maxCommits}`,
				"--date=iso",
				"--pretty=format:%h%x09%ad%x09%an%x09%s",
				...(input.path ? ["--", input.path] : []),
			],
			input.worktree,
		),
	]);

	if (statusRes.exitCode !== 0) return formatGitFailure("status", statusRes);
	if (logRes.exitCode !== 0) return formatGitFailure("log", logRes);

	const parsed = parseShortStatus(statusRes.stdout);
	const lines: string[] = [];

	lines.push("Pending changes:");
	lines.push(`- staged: ${parsed.staged}`);
	lines.push(`- unstaged: ${parsed.unstaged}`);
	lines.push(`- untracked: ${parsed.untracked}`);
	lines.push(`- conflicts: ${parsed.conflicts}`);

	if (parsed.files.length > 0) {
		lines.push("Changed files:");
		for (const file of parsed.files) {
			lines.push(`- ${file}`);
		}
	} else {
		lines.push("Changed files:");
		lines.push("- none");
	}

	lines.push("Recent local commits:");
	const commits = logRes.stdout.trim();
	if (commits.length === 0) {
		lines.push("- none");
	} else {
		for (const line of commits.split(/\r?\n/)) {
			lines.push(`- ${line}`);
		}
	}

	return lines.join("\n");
}

async function renderDiff(input: {
	worktree: string;
	base?: string;
	head?: string;
	path?: string;
	maxPatchLines: number;
}): Promise<string> {
	const pathArgs = input.path ? ["--", input.path] : [];

	if (input.base || input.head) {
		const range = `${input.base || "HEAD"}..${input.head || "HEAD"}`;
		const rangeRes = await runGit(
			["diff", "--stat", "--patch", range, ...pathArgs],
			input.worktree,
		);
		if (rangeRes.exitCode !== 0) return formatGitFailure("diff", rangeRes);
		return truncateLines(rangeRes.stdout, input.maxPatchLines);
	}

	const [unstagedRes, stagedRes] = await Promise.all([
		runGit(["diff", "--stat", "--patch", ...pathArgs], input.worktree),
		runGit(["diff", "--cached", "--stat", "--patch", ...pathArgs], input.worktree),
	]);

	if (unstagedRes.exitCode !== 0) return formatGitFailure("diff", unstagedRes);
	if (stagedRes.exitCode !== 0) return formatGitFailure("diff --cached", stagedRes);

	const sections = [
		"Unstaged diff:",
		unstagedRes.stdout.trim() || "(no unstaged changes)",
		"",
		"Staged diff:",
		stagedRes.stdout.trim() || "(no staged changes)",
	].join("\n");

	return truncateLines(sections, input.maxPatchLines);
}

async function renderLog(input: {
	worktree: string;
	path?: string;
	maxCommits: number;
}): Promise<string> {
	const args = [
		"log",
		`-n${input.maxCommits}`,
		"--date=iso",
		"--pretty=format:%h%x09%ad%x09%an%x09%s",
		...(input.path ? ["--", input.path] : []),
	];
	const res = await runGit(args, input.worktree);
	if (res.exitCode !== 0) return formatGitFailure("log", res);

	const trimmed = res.stdout.trim();
	if (!trimmed) return "No local commits found.";
	return trimmed;
}

async function renderShow(input: {
	worktree: string;
	rev: string;
	path?: string;
	maxPatchLines: number;
}): Promise<string> {
	const args = [
		"show",
		"--stat",
		"--patch",
		"--format=fuller",
		input.rev,
		...(input.path ? ["--", input.path] : []),
	];
	const res = await runGit(args, input.worktree);
	if (res.exitCode !== 0) return formatGitFailure("show", res);
	return truncateLines(res.stdout, input.maxPatchLines);
}

function parseShortStatus(content: string): {
	staged: number;
	unstaged: number;
	untracked: number;
	conflicts: number;
	files: string[];
} {
	let staged = 0;
	let unstaged = 0;
	let untracked = 0;
	let conflicts = 0;
	const files: string[] = [];

	for (const rawLine of content.split(/\r?\n/)) {
		const line = rawLine.trimEnd();
		if (!line) continue;

		if (line.startsWith("?? ")) {
			untracked += 1;
			files.push(line.slice(3));
			continue;
		}

		const x = line[0] || " ";
		const y = line[1] || " ";

		if (isConflictPair(x, y)) conflicts += 1;
		if (x !== " ") staged += 1;
		if (y !== " ") unstaged += 1;

		const pathPart = line.slice(3).trim();
		if (pathPart) files.push(pathPart);
	}

	return { staged, unstaged, untracked, conflicts, files };
}

const CONFLICT_PAIRS = new Set(["DD", "AU", "UD", "UA", "DU", "AA", "UU"]);

function isConflictPair(x: string, y: string): boolean {
	const pair = `${x}${y}`;
	return CONFLICT_PAIRS.has(pair);
}

async function runGit(args: string[], cwd: string): Promise<GitResult> {
	const proc = Bun.spawn(["git", ...args], {
		cwd,
		stdout: "pipe",
		stderr: "pipe",
	});

	const [stdout, stderr, exitCode] = await Promise.all([
		new Response(proc.stdout).text(),
		new Response(proc.stderr).text(),
		proc.exited,
	]);

	return {
		stdout: stdout.trim(),
		stderr: stderr.trim(),
		exitCode,
	};
}

function truncateLines(content: string, maxLines: number): string {
	const lines = content.split(/\r?\n/);
	if (lines.length <= maxLines) return content.trim() || "(no output)";
	const kept = lines.slice(0, maxLines);
	kept.push(`... truncated ${lines.length - maxLines} line(s)`);
	return kept.join("\n");
}

function clampInt(
	value: number | undefined,
	fallback: number,
	min: number,
	max: number,
): number {
	if (typeof value !== "number" || Number.isNaN(value)) return fallback;
	if (!Number.isFinite(value)) return fallback;
	const floored = Math.floor(value);
	if (floored < min) return min;
	if (floored > max) return max;
	return floored;
}

function validateRefInputs(input: {
	rev?: string;
	base?: string;
	head?: string;
}): string | null {
	if (startsWithDash(input.rev)) {
		return "Invalid rev: revision cannot start with '-'";
	}
	if (startsWithDash(input.base)) {
		return "Invalid base: revision cannot start with '-'";
	}
	if (startsWithDash(input.head)) {
		return "Invalid head: revision cannot start with '-'";
	}
	return null;
}

function startsWithDash(value: string | undefined): boolean {
	if (!value) return false;
	return value.trim().startsWith("-");
}

function formatGitFailure(command: string, result: GitResult): string {
	const output = [result.stdout, result.stderr].filter(Boolean).join("\n").trim();
	return `git ${command} failed with code ${result.exitCode}:${output ? `\n${output}` : ""}`;
}
