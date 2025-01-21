name: checkov
on:
  pull_request:
  push:
    branches:
      - main
jobs:
  scan:
    runs-on: ubuntu-latest
    permissions:
      contents: read # for actions/checkout to fetch code
      security-events: write # for GitHub/codeql-action/upload-sarif to upload SARIF results

    steps:
    - uses: actions/checkout@v2

    - name: Run checkov
      id: checkov
      uses: bridgecrewio/checkov-action@master
      with:
        directory: code/
        #soft_fail: true
        #api-key: ${{ secrets.BC_API_KEY }}
      #env:
        #PRISMA_API_URL: https://api4.prismacloud.io

    - name: Upload SARIF file
      uses: GitHub/codeql-action/upload-sarif@v2

      # Results are generated only on a success or failure
      # this is required since GitHub by default won't run the next step
      # when the previous one has failed. Alternatively, enable soft_fail in checkov action.
      if: success() || failure()
      with:
        sarif_file: results.sarif
