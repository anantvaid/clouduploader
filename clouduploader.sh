#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 /path/to/file.txt [--directory target_directory] [--storage-class storage_class] [--link]"
    echo "  --directory      Specify the target directory in the cloud storage."
    echo "  --storage-class  Specify the storage class (e.g., STANDARD, REDUCED_REDUNDANCY, STANDARD_IA, etc)."
    echo "  --link           Generate a shareable link after successful upload."
    exit 1
}

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    echo "Error: No file path provided."
    usage
fi

# Parse the file path
FILE_PATH="$1"

# Check if the file exists and is readable
if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File '$FILE_PATH' does not exist or is not readable."
    exit 1
fi

# Initialize optional parameters
TARGET_DIR=""
STORAGE_CLASS="STANDARD" # Default storage class
GENERATE_LINK=false

# Parse additional arguments
shift
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --directory)
            if [[ -n "$2" && "$2" != "--"* ]]; then
                TARGET_DIR="$2"
                shift
            else
                echo "Error: --directory requires a value."
                usage
            fi
            ;;
        --storage-class)
            if [[ -n "$2" && "$2" != "--"* ]]; then
                STORAGE_CLASS="$2"
                shift
            else
                echo "Error: --storage-class requires a value."
                usage
            fi
            ;;
        --link)
            GENERATE_LINK=true
            ;;
        *)
            echo "Error: Unknown option '$1'"
            usage
            ;;
    esac
    shift
done

# Prepare the S3 bucket and key
BUCKET_NAME="clouduploader-ttwa"
if [ -n "$TARGET_DIR" ];
then
	KEY="$TARGET_DIR/$(basename $FILE_PATH)"
else
	KEY="$(basename $FILE_PATH)"
fi

# Check if the file already exists in the S3 bucket
if aws s3 ls "s3://$BUCKET_NAME/$KEY" > /dev/null 2>&1; then
    echo "File '$KEY' already exists in the cloud."
    read -p "Do you want to (o)verwrite, (s)kip, or (r)ename? [o/s/r]: " CHOICE
    case $CHOICE in
        o|O) # Overwrite
            echo "Overwriting the file..."
            ;;
        s|S) 
            echo "Skipping upload."
            exit 0
            ;;
        r|R) 
            read -p "Enter new filename: " NEW_FILENAME
	    if [ -n "$TARGET_DIR" ];
	    then
        	KEY="$TARGET_DIR/$(basename $NEW_FILENAME)"
	    else
        	KEY="$(basename $NEW_FILENAME)"
	    fi
            ;;
        *) 
            echo "Invalid option. Exiting."
            exit 1
            ;;
    esac
fi

# Construct the AWS CLI command with pv for progress
AWS_COMMAND="aws s3 cp $FILE_PATH s3://$BUCKET_NAME/$KEY --storage-class $STORAGE_CLASS"
echo "Uploading '$FILE_PATH' to 's3://$BUCKET_NAME/$KEY' with storage class '$STORAGE_CLASS'..."

# Execute the command with pv for progress
pv "$FILE_PATH" | $AWS_COMMAND 2>&1
EXIT_STATUS=$?

# Check the exit status
if [ $EXIT_STATUS -eq 0 ]; then
    echo "Upload successful! File '$FILE_PATH' has been uploaded to 's3://$BUCKET_NAME/$KEY'."
    
    # Generate a shareable link if requested
    if $GENERATE_LINK; then
        SHAREABLE_LINK="https://$BUCKET_NAME.s3.amazonaws.com/$KEY"
        echo "Shareable link: $SHAREABLE_LINK"
    fi
else
    echo "Error: Upload failed."
    exit 1
fi
