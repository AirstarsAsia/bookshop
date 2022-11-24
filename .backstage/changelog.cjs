const fs = require("fs");
const path = require("path");

const version = process.env.GIT_VERSION;
const changelogFile = path.join(__dirname, "../CHANGELOG.md");
const releaseFile = path.join(__dirname, "../RELEASE.md");

const err = (m) => {
    console.error(m);
    process.exit(1);
}

const date = () => {
    let options = { year: 'numeric', month: 'long', day: 'numeric' };
    return new Date().toLocaleString('en-US', options);
}

if (!version) err("Script expected a GIT_VERSION environment variable");

if (!fs.existsSync(changelogFile)) err(`Script expected a file at ${changelogFile}`);

let fullRelease = /^\d+\.\d+\.\d+$/.test(version);
if (!fullRelease) {
    // No changelog for prereleases.
    console.log(`Building for a prerelease, skipping changelog`);
    process.exit(0);
}

let contents = fs.readFileSync(changelogFile, { encoding: "utf-8" });
let release = [], lines = contents.split(/\n/g);
let it = lines.entries();

while (!(entry = it.next()).done) {
    let [num, line] = entry.value;
    // Read until we reach our unreleased changelog section.
    if (/^\s*## Unreleased\s*$/.test(line)) {
        let releaseHeader = `## v${version} (${date()})`;
        lines[num] = `## Unreleased\n\n${releaseHeader}`;
        break;
    }
}


while (!(entry = it.next()).done) {
    let [, line] = entry.value;
    // Read until we reach the section for a new version.
    if (/^\s*##\s+v/i.test(line)) {
        break;
    }
    release.push(line);
}

if (!release.some((v => v.trim().length))) {
    err([
        `No unreleased changes exist in ${changelogFile}.`,
        `Cancelling release — please write release notes!`
    ].join('\n'));
}

if (process.argv[2] === "write") {
    fs.writeFileSync(releaseFile, release.join('\n'));
    fs.writeFileSync(changelogFile, lines.join('\n'));
}