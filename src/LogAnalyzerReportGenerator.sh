#!/bin/bash

# Check if at least one log file and one keyword are provided
if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <logfile1> <logfile2> ... -- <keyword1> <keyword2> ..."
    exit 1
fi

# Separate log files and keywords from command-line arguments
logfiles=()
keywords=()
in_files=true
for arg in "$@"; do
    if [[ "$arg" == "--" ]]; then
        in_files=false
        continue
    fi
    if $in_files; then
        logfiles+=("$arg")
    else
        keywords+=("$arg")
    fi
done

# Ensure at least one log file and one keyword are specified
if [[ ${#logfiles[@]} -eq 0 || ${#keywords[@]} -eq 0 ]]; then
    echo "Error: You must specify at least one log file and one keyword."
    exit 1
fi

# Add cron job if it does not exist
cron_job="0 1 * * * /home/sangee/unix.sh /home/sangee/log.log /home/sangee/log1.log -- ERROR INFO WARN >> /home/sangee/cron_output.log 2>&1"
(crontab -l | grep -F "$cron_job") || (crontab -l ; echo "$cron_job") | crontab -

# Function to check if the file exists and is readable
function check_file() {
    local file=$1
    if [[ -e "$file" && -r "$file" ]]; then
        return 0
    else
        echo "Error: Cannot access file '$file'"
        return 1
    fi
}

# Function to extract and count log entries based on keywords
function extract_logs() {
    local file=$1
    declare -A counts

    for keyword in "${keywords[@]}"; do
        counts[$keyword]=$(grep -c "$keyword" "$file")
    done

    for keyword in "${!counts[@]}"; do
        echo "$keyword: ${counts[$keyword]}"
    done
}

# Function to simplify timestamps and calculate hourly distributions
function calculate_distributions() {
    local file=$1
    declare -A hourly_counts
    declare -A ip_counts

    while read -r line; do
        if [[ $line =~ ([0-9]{4}-[0-9]{2}-[0-9]{2})\ ([0-9]{2}):[0-9]{2}:[0-9]{2} ]]; then
            date="${BASH_REMATCH[1]}"
            hour="${BASH_REMATCH[2]}:00:00"
            key="$date $hour"
            ((hourly_counts["$key"]++))
        fi
        if [[ $line =~ ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+) ]]; then
            ip="${BASH_REMATCH[1]}"
            ((ip_counts["$ip"]++))
        fi
    done < "$file"

    echo "Hourly Distributions:"
    for key in "${!hourly_counts[@]}"; do
        echo "$key: ${hourly_counts[$key]}"
    done

    echo "Total Log Entries by IP Address:"
    for ip in "${!ip_counts[@]}"; do
        echo "$ip: ${ip_counts[$ip]}"
    done
}

# Function to generate a summary report
function generate_report() {
    local file=$1
    local output_file=$2

    echo "Generating report..."
    {
        echo "Summary Report for $file"
        echo "--------------------------"
        extract_logs "$file"
        echo "--------------------------"
        calculate_distributions "$file"
    } > "$output_file"

    echo "Summary report saved to $output_file"
}

# Function to highlight keywords in log entries
function highlight_keywords() {
    local line=$1
    local highlighted_line=$line

    for keyword in "${keywords[@]}"; do
        case "$keyword" in
            "ERROR")
                highlighted_line=$(echo "$highlighted_line" | sed "s/$keyword/\x1b[31m&\x1b[0m/g")  # Red
                ;;
            "INFO")
                highlighted_line=$(echo "$highlighted_line" | sed "s/$keyword/\x1b[32m&\x1b[0m/g")  # Green
                ;;
            "WARN")
                highlighted_line=$(echo "$highlighted_line" | sed "s/$keyword/\x1b[33m&\x1b[0m/g")  # Yellow
                ;;
            *)
                highlighted_line=$(echo "$highlighted_line" | sed "s/$keyword/\x1b[36m&\x1b[0m/g")  # Cyan for other keywords
                ;;
        esac
    done

    echo -e "$highlighted_line"
}

# Function to process multiple log files
function process_multiple_files() {
    local files=("$@")

    for file in "${files[@]}"; do
        if check_file "$file"; then
            echo "Processing file: $file"
            output_file="${file%.*}_summary.txt"
            generate_report "$file" "$output_file"

            echo "Highlighted log entries:"
            while read -r line; do
                highlight_keywords "$line"
            done < "$file"
        fi
    done
}

# Main function
function main() {
    process_multiple_files "${logfiles[@]}"
}

# Execute main function
main
