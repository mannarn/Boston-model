# Define hyperparameter ranges
$n_estimators_list = @(100, 200)
$max_depth_list = @(5, 7)
$learning_rate_list = @(0.01, 0.1)
$subsample_list = @(0.6, 0.8)

# Replace placeholders in YAML and submit Jobs
foreach ($n in $n_estimators_list) {
    foreach ($depth in $max_depth_list) {
        foreach ($lr in $learning_rate_list) {
            foreach ($sub in $subsample_list) {
                $yamlContent = (Get-Content job-hyperparameter.yaml -Raw) `
                    -replace '\{\{N_ESTIMATORS\}\}', $n `
                    -replace '\{\{MAX_DEPTH\}\}', $depth `
                    -replace '\{\{LEARNING_RATE\}\}\}', $lr `
                    -replace '\{\{SUBSAMPLE\}\}\}', $sub
                
                # Debug statement
                Write-Output "Submitting job with n_estimators=$n, max_depth=$depth, learning_rate=$lr, subsample=$sub"
                
                # Pipe the modified YAML content to kubectl apply
                $yamlContent | kubectl apply -f -
            }
        }
    }
}