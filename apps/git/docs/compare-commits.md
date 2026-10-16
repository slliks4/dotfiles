### 1. View Everything About a Commit (Recommended)

To see the commit details (author, date, message) along with the line-by-line diff of the changes made in that commit:

```bash
git show <commit-hash>

```

**Common variations:**

* **See summary of changed files only:**
```bash
git show --stat <commit-hash>

```


* **See only the filenames changed:**
```bash
git show --name-only <commit-hash>

```



---

### 2. Compare the Commit to Your Current Branch

If you want to compare the changes in that specific commit against your current working branch or `HEAD`:

* **Diff a specific commit against your current `HEAD`:**
```bash
git diff <commit-hash> HEAD

```


* **Diff two specific commits against each other:**
```bash
git diff <commit-hash-1> <commit-hash-2>

```



---

### 3. Inspect a Single File from That Commit

If you want to view how a specific file looked at that exact commit without changing your working directory:

```bash
git show <commit-hash>:path/to/file

```
