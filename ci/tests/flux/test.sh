output=$(flux start flux mini run echo Success)
if [[ "$output" != "Success" ]]; then
    exit 1
fi

echo "Success!"
