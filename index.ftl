<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Report</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
</head>
<body>
  <#if executionStatus == "PASS">
    <#assign overallStatus = "success">
  <#else>
    <#assign overallStatus = "danger">
  </#if>
  <nav class="navbar navbar-expand-lg navbar-light bg-${overallStatus}">
    <a href="#" class="navbar-brand text-light">Report</a>
  </nav>

  <main class="container-fluid">
    <!-- BEGIN: Test Data Modal -->
    <div class="modal fade" id="testDataModal" tabindex="-1" role="dialog" aria-labelledby="testDataModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="testDataModalLabel">Test Data</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>

          <div class="modal-body">
            <pre id="testDataJson"></pre>
          </div>
  
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>
    <!-- END: Test Data Modal -->

    <!-- BEGIN: Stack Trace Modal -->
    <div class="modal fade" id="stackTraceModal" tabindex="-1" role="dialog" aria-labelledby="stackTraceModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="stackTraceModalLabel">Stacktrace</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>

          <div class="modal-body">
            <pre id="stackTraceData" class="text-danger"></pre>
          </div>
  
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>
    <!-- END: Stack Trace Modal -->

    <div class="row mt-2">
      <div class="col-lg">
        <div class="card text-center border-${overallStatus}">
          <div class="card-header">Groups</div>
          <div class="card-body">
            <p class="card-text">${testGroupTagName}</p>
          </div>
        </div>
      </div>

      <div class="col-lg">
        <div class="card text-center border-${overallStatus}">
          <div class="card-header">Summary</div>
          <div class="card-body">
            <div class="card-text">
              <span>Total: ${total}</span>&nbsp;|&nbsp;
              <span class="text-success">Pass: ${pass}</span>&nbsp;|&nbsp;
              <span class="text-danger">Fail: ${fail}</span>&nbsp;|&nbsp;
              <span class="text-warning">Skip: ${skip}</span>
            </div>
          </div>
        </div>
      </div>

      <div class="col-lg">
        <div class="card text-center border-${overallStatus}">
          <div class="card-header">Execution time</div>
          <div class="card-body">
            <p class="card-text">${executionTime}</p>
          </div>
        </div>
      </div>

      <div class="col-lg">
        <div class="card text-center border-${overallStatus}">
          <div class="card-header">Application / Release / Environment / Browser </div>
          <div class="card-body">
            <p class="card-text">${application} / ${release} / ${environment} / ${browserName} </p>
          </div>
        </div>
      </div>
    </div>

    <div class="row m-3">
      <table class="table table-bordered table-sm">
        <thead>
          <tr>
            <th scope="col">Test Suite</th>
            <th scope="col">Test Case Name</th>
            <th scope="col">Duration</th>
            <th scope="col">Test Data</th>
            <th scope="col">Status</th>
            <th scope="col">Test Evidence</th>
            <th scope="col">Failed Reason</th>
          </tr>
        </thead>
        <tbody>
          <#list testSuites as testSuite>
            <#assign suiteFlag = true>
            <#list testSuite.testMethods as testMethod>
              <tr>
                <#if suiteFlag>
                  <th class="text-center align-middle" scope="row" rowspan="${testSuite.testMethods?size}">${testSuite.suiteName}</th>
                  <#assign suiteFlag = false>
                </#if>
                <td class="align-middle">${testMethod.name}</td>
                <td class="align-middle">${testMethod.duration}</td>
                <td class="align-middle">
                  <button type="button" class="btn btn-link" data-toggle="modal" data-target="#testDataModal" data-testdata='${testMethod.testData}'>View</button>
                </td>
                <#if testMethod.status == "PASS">
                  <#assign status = "text-success">
                <#elseif testMethod.status == "FAIL">
                  <#assign status = "text-danger">
                <#else>
                  <#assign status = "text-warning">
                </#if>
                <td class="${status} align-middle">${testMethod.status}</td>
                <td class="align-middle">
                  <a href="${testMethod.screenshotFile}" target="_blank">Download</a>
                </td>
                <td class="text-danger align-middle">
                  <#if testMethod.failedReason != "">
                    <span>${testMethod.failedReason}<span>&nbsp;
                    <button type="button" class="btn btn-link" data-toggle="modal" data-target="#stackTraceModal" data-stacktrace="${testMethod.stackTrace}">More...</button>
                  </#if>
                </td>
              </tr>
            </#list>
          </#list>
        </tbody>
      </table>
    </div>
  </main>

  <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

  <!-- User-defined javascript -->
  <script>
    // For test data modal
    $('#testDataModal').on('show.bs.modal', function(event) {
      var button = $(event.relatedTarget);
      var testDataRaw = button.data("testdata");

      var modal = $(this);
      modal.find('.modal-body pre#testDataJson').text(JSON.stringify(testDataRaw, undefined, 2));
    });

    // For stack trace modal
    $('#stackTraceModal').on('show.bs.modal', function(event) {
      var button = $(event.relatedTarget);
      var stackTraceRaw = escape(""+button.data("stacktrace"));

      var modal = $(this);
      modal.find('.modal-body pre#stackTraceData').text(unescape(stackTraceRaw));
    });
  </script>
</body>
</html>
