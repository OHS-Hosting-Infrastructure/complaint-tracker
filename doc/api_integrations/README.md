# API Integrations

The Complaints Tracker relies on the following systems in a read-only capacity:

- HSES
  - Authentication
  - [Data](https://github.com/OHS-Hosting-Infrastructure/complaint-tracker-api-docs) (private)
    - complaints (issues)
- [TTA Hub](https://github.com/HHS/Head-Start-TTADP/blob/main/docs/openapi/paths/api/activityReportByDisplay.yaml)
  - activity reports (AR)

For information about whether fake data or data from API calls will be used in the app, as well as how to override this behavior, see [API Connections](/README.md#api-connections).
