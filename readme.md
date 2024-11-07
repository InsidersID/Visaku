# Commit Message Guidelines

To maintain a consistent and readable commit history, all commits should follow the conventions outlined below:

| **Function**                                                       | **Commit Message Format** | **Example**                                                 |
| ------------------------------------------------------------------ | ------------------------- | ----------------------------------------------------------- |
| New feature for the user, not a new feature for build script       | `feat: <description>`     | `feat: Add document applying link to a profile`             |
| Bug fix for the user, not a fix to a build script                  | `fix: <description>`      | `fix: Fix undesired behavior when printing a document`      |
| Changes to the documentation                                       | `docs: <description>`     | `docs: Change the API endpoint info`                        |
| Formatting, missing semicolons, etc.; no production code changes   | `style: <description>`    | `style: Add comma to several comments`                      |
| Refactoring production code, e.g. renaming a variable              | `refactor: <description>` | `refactor: Rename PengajuanVisaView to VisaApplicationView` |
| Adding missing tests, refactoring tests, no production code change | `test: <description>`     | `test: Unit testing for Identity Repository`                |
| Changes to build process or libraries                              | `chore: <description>`    | `chore: Add lottie and swiftlint`                           |

## Every Commit Rule

In addition to the message format, each commit should adhere to the following rules:

1. **Descriptive Commit Messages:**

   - Commit messages should be written in the imperative form and clearly describe the action taken.
   - **Example:** `feat: Add login button to profile page`

2. **One Change per Commit:**

   - Each commit should focus on a single change (feature, bug fix, refactor, etc.). Avoid mixing multiple changes in the same commit.

3. **Commit Prefix Format:**

   - If using issue tracking (e.g., JIRA), prefix your commit message with the issue key in the following format:
     - **Format:** `(MERGE)-JIRAXXX-<description>`
     - **Example:** `(MERGE)-JIRA123-feat: Add login button to profile page`

4. **UI/Visual Changes:**

   - For commits that involve UI changes, consider attaching a video or GIF showing the before and after, making it easier for others to review the visual impact.

5. **Frequent, Small Commits:**
   - Commit small changes frequently rather than waiting for larger batches of work. This makes it easier to isolate and debug issues when necessary.
