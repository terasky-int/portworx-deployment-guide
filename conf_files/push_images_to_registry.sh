#!/bin/bash

# This script will push any tar file to a registry 
# Make sure the file name is with version and path to image.
# Examples for file names: 
# * prometheus@alertmanager_v0.26.0.tar            - Parsed into prometheus/alertmanager:v0.26.0
# * monitoring_prometheus@alertmanager_v0.26.0.tar - Parsed into monitoring/prometheus/alertmanager:v0.26.0
# * alertmanager_v0.26.0.tar                       - Parsed into alertmanager:v0.26.0

# After pushing an image the file name will be marked as done and running the script again wont affect it.


# Check if a directory is provided
if [ -z "$1" ]; then
    echo "No directory provided"
    exit 1
fi

# Check if the directory exists
if [ ! -d "$1" ]; then
    echo "Directory not found: $1"
    exit 1
fi

# Iterate over all .tar files in the directory
for file in "$1"/*.tar; do
    # Check if the file exists
    if [ ! -f "$file" ]; then
        echo "File not found: $file"
        continue
    fi

    # Extract the image name and version from the file name
    filename=$(basename "$file")

    # Check if the file name starts with "done_"
    if [[ $filename == done_* ]]; then
        echo "File name does start with 'done_': $filename"
        continue
    fi

    image_name="${filename%%_*}"
    image_name="${image_name//@//}"
    version="${filename##*_}"
    version="${version%.tar}"
    tag="your-custom-registry-domain/px-images/<PORTWORX VERISON>/$image_name:$version" # CHANGE ME

    # Load the image
    docker load < "$file"
    echo $file

    # Extract the image name from the image_name variable
    search_phrase_image_name=$image_name
    echo $search_phrase_image_name

    # Extract the image name from the image name variable
    if [[ $image_name == *"/"* ]]; then
        search_phrase_image_name=$(echo "$image_name" | awk -F'/' '{print $2}')
    fi
    echo $search_phrase_image_name

    actual_image_name=$(docker images | grep "$search_phrase_image_name" | awk '{print $1}')

    echo "Image name: $actual_image_name"
    echo "Version: $version"
    echo "Tag: $tag"
    echo "Actual image name: $actual_image_name"

    read -p "Approve? (y)" input

    if [[ $input == "y"]]; then

        # Tag the image
        docker tag "$actual_image_name:$version" "$tag"

        echo "Image tagged as $tag"

        # Push the image
        docker push "$tag"

        # Mark as done
        mv $filename "done_$filename"

        echo "Image pushed to $tag"
    fi

done