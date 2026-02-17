import { tool } from "@opencode-ai/plugin";
import path from "path";

type TargetInfo = {
	name: string;
	description?: string;
};

const DESCRIPTION = [
	"Primary project automation tool.",
	"Use this for build, test, verification, formatting, linting, checks, and other make-driven workflows from the worktree root.",
	"Start by running target 'help' to discover available project targets, then choose the appropriate target based on that output.",
	"Prefer this tool over direct bash commands whenever possible.",
];

async function runMake(args: string[], cwd: string): Promise<string> {
	const proc = Bun.spawn(["make", ...args], {
		cwd,
		stdout: "pipe",
		stderr: "pipe",
	});

	const [stdout, stderr, exitCode] = await Promise.all([
		new Response(proc.stdout).text(),
		new Response(proc.stderr).text(),
		proc.exited,
	]);

	const combined = [stdout, stderr].filter(Boolean).join("\n").trim();
	const output = combined || "(no output)";

	if (exitCode !== 0) {
		return `make exited with code ${exitCode}:\n${output}`;
	}

	return output || "make completed successfully";
}

export default tool({
	description: DESCRIPTION.join(" "),
	args: {
		target: tool.schema
			.string()
			.optional()
			.describe(
				[
					"Make target to execute (examples: help, build, test, check, fmt, lint, verify).",
					"Use 'help' first to list supported targets.",
				].join(" "),
			),
	},
	async execute(args, context) {
		const worktree = context.worktree;
		const makefilePath = path.join(worktree, "Makefile");
		const makefile = Bun.file(makefilePath);
		const target = args.target?.trim();
		const wantsHelp = target === "help";
		const effectiveTarget = target || "default";

		if (!(await makefile.exists())) {
			return wantsHelp
				? "No Makefile found in worktree root."
				: "Skipped: no Makefile found in worktree root.";
		}

		if (wantsHelp) {
			const content = await makefile.text();
			const hasHelpTarget = parseTargets(content).some(
				(item) => item.name === "help",
			);

			await context.ask({
				permission: "make",
				patterns: ["help"],
				always: ["*"],
				metadata: {
					target: "help",
					worktree,
					path: makefilePath,
					mode: hasHelpTarget ? "make-help" : "generated-help",
				},
			});

			if (!hasHelpTarget) {
				return formatHelp(content);
			}

			return runMake(["help"], worktree);
		}

		await context.ask({
			permission: "make",
			patterns: [effectiveTarget],
			always: ["*"],
			metadata: {
				target: effectiveTarget,
				worktree,
				path: makefilePath,
				mode: target ? "make-target" : "make-default",
			},
		});

		return runMake(target ? [target] : [], worktree);
	},
});

function formatHelp(makefileContent: string): string {
	const targets = parseTargets(makefileContent);
	if (targets.length === 0) {
		return "No callable make targets found in Makefile.";
	}

	const lines = ["Available make targets:"];
	for (const target of targets) {
		lines.push(
			target.description
				? `- ${target.name}: ${target.description}`
				: `- ${target.name}`,
		);
	}

	return lines.join("\n");
}

function parseTargets(makefileContent: string): TargetInfo[] {
	const lines = makefileContent.split(/\r?\n/);
	const targets: TargetInfo[] = [];
	const seen = new Set<string>();
	let pendingDocLines: string[] = [];

	for (const line of lines) {
		const trimmed = line.trim();

		if (trimmed.startsWith("##")) {
			const doc = trimmed.replace(/^##\s?/, "").trim();
			if (doc.length > 0) pendingDocLines.push(doc);
			continue;
		}

		const match = line.match(
			/^([A-Za-z0-9_./-][A-Za-z0-9_./-]*)\s*:(?![=])(.*)$/,
		);
		if (match) {
			const name = match[1];
			const rest = match[2] ?? "";

			pendingDocLines = pendingDocLines.filter((item) => item.length > 0);

			if (name.startsWith(".") || name.includes("%") || seen.has(name)) {
				pendingDocLines = [];
				continue;
			}

			const inlineDocMatch = rest.match(/\s##\s*(.+)$/);
			const inlineDoc = inlineDocMatch?.[1]?.trim();
			const description = inlineDoc || pendingDocLines.join(" ") || undefined;

			targets.push({ name, description });
			seen.add(name);
			pendingDocLines = [];
			continue;
		}

		if (
			trimmed.length === 0 ||
			trimmed.startsWith("#") ||
			line.startsWith("\t")
		) {
			continue;
		}

		pendingDocLines = [];
	}

	return targets;
}
