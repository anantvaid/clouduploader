# Troubleshooting Guide 🛠️

### 1. AWS CLI Errors
**Issue:** Script fails with `Error: AWS CLI is not installed. Please install it first.`

**Cause:** The AWS CLI is not installed on your system.

**Solution:**
- Install the AWS CLI following the [official installation guide](https://aws.amazon.com/cli/).

<hr/>

**Issue:** Script fails with `Error: AWS credentials are not configured. Please run 'aws configure'.`

**Cause:** AWS credentials are not set up or configured properly.

**Solution:**
- Run `aws configure` in your terminal. Provide your Access Key ID, Secret Access Key, default region, and output format.
- Check the configuration files located in `~/.aws/config` and `~/.aws/credentials` for correctness.

<hr/>

### 2. File Not Found or Not Readable
**Issue:** Script fails with `Error: File 'path/to/file.txt' does not exist or is not readable.`

**Cause:** The specified file path is incorrect or the file does not have the right permissions.

**Solution:**

- Verify the file path. Use `ls /path/to/file.txt` to check if the file exists.
- Check file permissions with `ls -l /path/to/file.txt` and adjust using `chmod` if necessary (e.g., `chmod +r /path/to/file.txt`).

<hr/>

### 3. Permission Denied on Upload
**Issue:** Upload fails with an `Access Denied` error from AWS.

**Cause:** The IAM user does not have sufficient permissions for the specified S3 bucket.

**Solution:**

- Review the IAM user’s permissions. Ensure that it has the `s3:PutObject` permission for the target bucket.
- Check bucket policies that might restrict access.

<hr/>

### 4. Progress Bar Not Displaying
**Issue:** The upload does not show a progress bar.

**Cause:** The `pv` command might not be installed.

**Solution:**

- Install `pv` using your package manager. For example, on Ubuntu:
```bash
sudo apt install pv
```

- Verify installation with `pv --version`.

<hr/>

### 5. File Already Exists in S3
**Issue:** Confusion on whether to overwrite, skip, or rename the file.

**Cause:** The script prompts the user for input but may not provide clear guidance.

**Solution:**

- Read the prompts carefully. If you choose to rename, provide a valid new filename.
- Ensure the target directory has the right naming conventions (no special characters, etc.).

<hr/>

### 6. Shareable Link Not Working
**Issue:** The generated shareable link returns a 403 Forbidden error.

**Cause:** The S3 bucket policy may not allow public access.

**Solution:**

- Check the bucket policy to ensure it allows public access or provides pre-signed URLs for the objects.
- If using a pre-signed URL, ensure you have the correct permissions.

<hr/>

### 7. General Script Errors
**Issue:** The script exits with an `unknown option` error.

**Cause:** Invalid command-line options are provided.

**Solution:**

- Review the usage message by running the script without arguments or with `--help`.
- Ensure all flags are properly formatted (e.g., `--directory`, `--storage-class`).

<hr/>

## Additional Tips
- **Debugging:** Add `set -x` at the top of the script to enable debugging. This will print each command being executed.
- **Logging:** Consider redirecting output and error messages to a log file for later review:
```bash
./clouduploader /path/to/file.txt > upload.log 2>&1
```
- **Documentation:** Refer to the AWS CLI documentation for specific command usage and options.
