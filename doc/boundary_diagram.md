System Boundary Diagram
=======================

![rendered boundary diagram](http://www.plantuml.com/plantuml/png/fLNVR-9647xdhvZoK16fW9fBNwggEW8SYKGK59FUoqbelHvWbMNNtPs5M5N-z-xOi52WLQMJ4cpFZsy-pyn-_kn9E0eRtVf16Qb3WR0cAlsl_RuJkzvAqJhamQEJrX0QwacxwOl2AM6sEfIXFxphphGmzFeqxMj1w2cQ5iCOBPH1roiPcnHfXA7Tb3fQ2UPEo3TqaDjW2k4gs2hSjMRel3MTihuOr3z1-pBbDN9fHy_009gYozJ0Be7ML_3RDmVC0hUeRKI-YZawUDjNtIdPWp05JEPF4VX-JxqZTfxfVCrWOhT3RKFHle6_MW0fGh9nPRSnhBxjnVjz341MUSBDOlnEZBGGEZyD0sr5qSs55aOolQRGO7hVlZdBJbKMebJ_W1ZC7lyZsjb0TLj--r6B2ft_7OwfZTFNRM4ZVE5tSXMG4ykbak3HRPN4FVwn9sHpvYgbmqAH86LDygPN1qXhqjdjTf5uUShZohvynHm6PQcLh26Prql8AuZeBqBfckX8-PXLDREILckKv44Ui3mKWaGFde8cLMe4PJnnTpsuO8mog_WoP-n6UIToMt1YBZnUtw6zaodChAULmvfEHjRXPVrzaOyM_t-qcibq7h9n5dFuKkT6DXeXKoi3p-QRUVeoWAqIC5SRxDx7OWLt0wo3sUCV88KhliMep0OdaG-5CegKqCT6-ffchFs2-lIS7JTl8unOuP5kpPQvrAe0a_6yFtlEui_hl3yQJyVpCNJkxZxTH4nZ2S6frPfu7bgPjzP0Qv1SG_AuF1HOAabOW708QAIhIdxQALh3V9h1pxrR24QZzs1fZMwdF0BZ5hqMcgA-hRadmfTxN3hxhdYQ-6T0J_x_aMVG2woqbDy1cZ3EDiWtUy5Bwf2SmYtwr6oI9NH-kVjqUu6otv132Wp_VL29nZK04MYDXlWWeOUm5zNdGJJVdkz7IjgYKyiALC6PL5qs8PLCIh3NpatCM7WXF9-Tn_vm13DLebO66pKubQRccnC39ueUGbxpUiYwqXfoV9pvL1S83alh5LaMb6i02z4iNGA2GMDeHDwGCi463u-6SEKQYSgId7rm2qu_6udLBEHQ-NLDWg6Y0tnyxjocQHrYBuZ4QMrY-DhQDzvbjUITcd1KOWTaMOYWwLAPkfI0Jm7FD7-4fROLYAD2GlppGKhqVXbq0yhm4MyggiNeJ0GQwqkZGutXCveYRFJV)

UML Source
----------

```
@startuml
!include https://raw.githubusercontent.com/adrianvlupu/C4-PlantUML/latest/C4_Container.puml
title Complaint Tracker boundary view
Person(personnel, "Complaint Tracker User", "An end-user of the Complaint Tracker")
Person(developer, "Complaint Tracker Developer", "Complaint Tracker developers and GTM")
Boundary(aws, "AWS GovCloud") {
  Boundary(cloudgov, "cloud.gov") {
    System_Ext(aws_alb, "cloud.gov load-balancer", "AWS ALB")
    System_Ext(cloudgov_api, "cloud.gov API")
    System_Ext(cloudgov_router, "<&layers> cloud.gov routers", "Cloud Foundry traffic service")
    Boundary(atob, "Accreditation Boundary") {
      Container(www_app, "<&layers> Complaint Tracker Web Application", "Ruby on Rails", "Displays and collects complaints data. Multiple instances running")
      ContainerDb(app_database, "Complaint Tracker Database", "Postgres", "Stores complaints data.")
    }
  }
}
System(HSES, "HSES", "Single Sign On\nMFA via Time-Based App or PIV card\n\nSource of initial Complaints Data")
Rel(personnel, aws_alb, "manage complaint data", "https GET/POST/PUT/DELETE (443)")
note right on link
All connections depicted are encrypted with TLS 1.2 unless otherwise noted.
end note
Rel(aws_alb, cloudgov_router, "proxies requests", "https GET/POST/PUT/DELETE (443)")
Rel(cloudgov_router, www_app, "proxies requests", "https GET/POST/PUT/DELETE (443)")
Rel(www_app, app_database, "stores and retrieves data", "tcp (5432)")
Rel(www_app, HSES, "retrieve Complaint data", "https GET (443)")
Rel(www_app, HSES, "authenticates user", "OAuth2")
Rel(personnel, HSES, "verify identity", "https GET/POST (443)")
Boundary(development_saas, "CI/CD Pipeline") {
  System_Ext(github, "GitHub", "OHS-controlled code repository")
  System_Ext(github_actions, "GitHub Actions", "Continuous Integration Service")
}
Rel(developer, github, "Publish code", "git ssh (22)")
Rel(github, github_actions, "Commit hook notifies Github Actions to run CI/CD pipeline")
Rel(github_actions, cloudgov_api, "Deploy application on successful CI/CD run")
Lay_D(personnel, aws)
Lay_R(HSES, aws)
@enduml
```

Instructions
------------

1. [Edit this diagram with plantuml.com](http://www.plantuml.com/plantuml/png/fLNVR-9647xdhvZoK16fW9fBNwggEW8SYKGK59FUoqbelHvWbMNNtPs5M5N-z-xOi52WLQMJ4cpFZsy-pyn-_kn9E0eRtVf16Qb3WR0cAlsl_RuJkzvAqJhamQEJrX0QwacxwOl2AM6sEfIXFxphphGmzFeqxMj1w2cQ5iCOBPH1roiPcnHfXA7Tb3fQ2UPEo3TqaDjW2k4gs2hSjMRel3MTihuOr3z1-pBbDN9fHy_009gYozJ0Be7ML_3RDmVC0hUeRKI-YZawUDjNtIdPWp05JEPF4VX-JxqZTfxfVCrWOhT3RKFHle6_MW0fGh9nPRSnhBxjnVjz341MUSBDOlnEZBGGEZyD0sr5qSs55aOolQRGO7hVlZdBJbKMebJ_W1ZC7lyZsjb0TLj--r6B2ft_7OwfZTFNRM4ZVE5tSXMG4ykbak3HRPN4FVwn9sHpvYgbmqAH86LDygPN1qXhqjdjTf5uUShZohvynHm6PQcLh26Prql8AuZeBqBfckX8-PXLDREILckKv44Ui3mKWaGFde8cLMe4PJnnTpsuO8mog_WoP-n6UIToMt1YBZnUtw6zaodChAULmvfEHjRXPVrzaOyM_t-qcibq7h9n5dFuKkT6DXeXKoi3p-QRUVeoWAqIC5SRxDx7OWLt0wo3sUCV88KhliMep0OdaG-5CegKqCT6-ffchFs2-lIS7JTl8unOuP5kpPQvrAe0a_6yFtlEui_hl3yQJyVpCNJkxZxTH4nZ2S6frPfu7bgPjzP0Qv1SG_AuF1HOAabOW708QAIhIdxQALh3V9h1pxrR24QZzs1fZMwdF0BZ5hqMcgA-hRadmfTxN3hxhdYQ-6T0J_x_aMVG2woqbDy1cZ3EDiWtUy5Bwf2SmYtwr6oI9NH-kVjqUu6otv132Wp_VL29nZK04MYDXlWWeOUm5zNdGJJVdkz7IjgYKyiALC6PL5qs8PLCIh3NpatCM7WXF9-Tn_vm13DLebO66pKubQRccnC39ueUGbxpUiYwqXfoV9pvL1S83alh5LaMb6i02z4iNGA2GMDeHDwGCi463u-6SEKQYSgId7rm2qu_6udLBEHQ-NLDWg6Y0tnyxjocQHrYBuZ4QMrY-DhQDzvbjUITcd1KOWTaMOYWwLAPkfI0Jm7FD7-4fROLYAD2GlppGKhqVXbq0yhm4MyggiNeJ0GQwqkZGutXCveYRFJV)
1. Copy and paste the final UML into the UML Source section
1. Update the img src and edit link target to the current values

### Notes

* See the help docs for [C4 variant of PlantUML](https://github.com/RicardoNiepel/C4-PlantUML) for syntax help.
