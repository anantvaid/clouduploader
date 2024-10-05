# clouduploader
A simple bash-based CLI utility that enables user to quickly upload files to the remote bucket in AWS S3. It provides features like progress tracking and shareable links, making file uploads efficient and secure.

## Features 🚀

- **Seamless Upload**: Easily upload files to your cloud storage.
- **Progress Bar**: Visual feedback on upload progress using `pv`.
- **File Synchronization**: Options to overwrite, skip, or rename existing files.
- **Shareable Links**: Generate links to share uploaded files.


## Requirements 🛠️

Before using the script, ensure you have the following installed:
1. **AWS CLI**: [Installation Guide](https://aws.amazon.com/cli/)
2. **pv**: For displaying the progress bar.
   - On Ubuntu: `sudo apt install pv`
   - On macOS: `brew install pv`

## Installation ⚙️

1. Clone the repository:
   ```bash
   git clone https://github.com/anantvaid/clouduploader.git
   cd clouduploader
   ```
2. Make the script executable
   ```bash
   chmod +x clouduploader.sh
   ```

## Usage 📜
Run the script with the required parameters:
   ```bash
   ./clouduploader /path/to/file.txt [--directory target_directory] [--storage-class storage_class] [--link]
   ```

### Parameters:
- `/path/to/file.txt`: The path of the file to upload.
- `--directory`: Specify the target directory in the cloud storage.
- `--storage-class`: Specify the storage class (e.g., STANDARD, REDUCED_REDUNDANCY).
- `--link`: Generate a shareable link after successful upload.

### Example
```bash
./clouduploader /path/to/file.txt --directory my_directory --storage-class STANDARD --encrypt your_password --link
```

## Troubleshooting 🛡️
Refer to the [Troubleshooting Guide](https://github.com/anantvaid/clouduploader/blob/main/TROUBLESHOOTING.md) for common issues and solutions.

## License 📝
This project is licensed under the MIT License - see the [LICENSE](https://github.com/anantvaid/clouduploader/blob/main/LICENSE) file for details.

## Contributions 🤝
Feel free to submit issues or pull requests for improvements!

## Author ✨
Anant Vaid - [GitHub Profile](https://github.com/anantvaid/)
