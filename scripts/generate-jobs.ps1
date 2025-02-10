# Define hyperparameter ranges
$n_estimators_list = @(100, 200)
$max_depth_list = @(5, 7)
$learning_rate_list = @(0.01, 0.1)
$subsample_list = @(0.6, 0.8)

# Process all combinations
foreach ($n in $n_estimators_list) {
    foreach ($depth in $max_depth_list) {
        foreach ($lr in $learning_rate_list) {
            foreach ($sub in $subsample_list) {
                # Sanitize values with dots (e.g., 0.01 → 0-01 for Kubernetes naming)
                $sanitized_lr = "$lr".Replace(".", "-")
                $sanitized_sub = "$sub".Replace(".", "-")

                # Read template and replace placeholders
                $yamlContent = (Get-Content "C:/Users/manna/Desktop/Boston-model/job-hyperparameter.yaml" -Raw) `
                    -replace '\{\{N_ESTIMATORS\}\}', $n `
                    -replace '\{\{MAX_DEPTH\}\}\}', $depth `
                    -replace '\{\{LEARNING_RATE\}\}\}', $sanitized_lr `
                    -replace '\{\{SUBSAMPLE\}\}\}', $sanitized_sub `
                    -replace '\{\{LEARNING_RATE_RAW\}\}', $lr `
                    -replace '\{\{SUBSAMPLE_RAW\}\}', $sub

                # Debug statement to verify replacement
                Write-Output "YAML Content:"
                Write-Output $yamlContent

                # Submit job
                Write-Output "Submitting job: trial-$n-$depth-$sanitized_lr-$sanitized_sub"
                $yamlContent | kubectl apply -f -
            }
        }
    }
}