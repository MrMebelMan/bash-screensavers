# 🏛️ The Jury Box

Welcome, esteemed member of the jury! This is the gallery's quality control center, where we deliberate on the artistic merits of our shell-based screensavers.

Our primary tool for examination is **Bats** (`Bash Automated Testing System`), a framework that lets us put our scripts through their paces to ensure they are pixel-perfect for our viewers.

## Assembling the Jury

Before the trial can begin, you must assemble your fellow jurors. In less metaphorical terms, you need to download the Bats testing framework and its essential helper libraries.

We've commissioned a special script to handle this for you. From the root of the repository, please execute:

```bash
./jury/assemble-the-jury.sh
```

This script will meticulously gather the required evidence (our dependencies) and place them in a newly created `jury/test_libs/` directory. This directory is listed in our `.gitignore` file, so you won't accidentally submit your jury summons to our version control.

The script will procure:
*   `bats-core`: The honorable judge and framework itself.
*   `bats-support`: The ever-helpful court clerk.
*   `bats-assert`: The sharp-witted prosecution, ready to make assertions.

## Running the Tests

Once you have assembled the jury, you can run the full test suite with the following command from the repository root:

```bash
./jury/test_libs/bats-core-1.12.0/bin/bats jury
```

### Rendering the Verdict

For your convenience, we have a master script that handles the entire judicial process. It assembles the jury and then runs the full test suite twice, saving the results in both human-readable and machine-readable formats.

To run this script, execute the following command from the repository root:
```bash
./jury/render-the-verdict.sh
```
This will create two files in the `jury/` directory:
*   `verdict.txt`: A "pretty" human-readable summary of the test results.
*   `verdict.tap`: A machine-readable TAP (Test Anything Protocol) output, suitable for integration with CI/CD systems or other automated tools.
 
 
 
 
