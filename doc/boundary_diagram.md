System Boundary Diagram
=======================

![rendered boundary diagram](http://www.plantuml.com/plantuml/png/fLHHRo8t47xdLqnvg8XKG4tpL5NL4U2II4H1MT9xEGaPxm2Z67jhZ-5MLVvxFRkRXJlegT8zmEwEPpv__ZpVV0YiFCUTwVn4LfkO8soPY_3xSEZLOR0XtiPL3EYriuoM1zhjXYhtfEpUn28EnpVzkL6MNnvdGwCO0wVGSfoo5LdqWqAmcTWWZDskC2dAiF1AlwA7bOisLxw4FU6XCqSVdEqLrSEY-GMwvoKlYKithOmieCtxGWtS6dXx0RzxzOwPunwDIyWNCIVlgzsBosrn06Lpk5iy9k3RXdfF7OBG-PJ1dTkFZOjvzmh-wG2q6Lg26xTFQTNh8BqtEG1P6HXto-aN5gIbCglJD31EvVsLCihgHA_PQ3IxJGo-hcvtMQg2le8OpH--a-rTv4gMFtusgaGV_eHZQRqOAbaa21_bJBu4zcgz9Wq1_PuqDlX7JTYjXAlM7dDYnUHikzeU7Q1jazxXS4Z4YrCU5_hb4wvWL1I6T0Kfl9xZgeI4_gp810bCA1G9eRuhxOn1pG7qErQ0NB4Qm6CqJ8L181jOr0tWexLaDyrXtZhoU-lKelNkiscMqEKXksGfCHLdjB7mP3_RnuyZs9E21UsmVwi2va8Kd8Vvmr-WbSy_fwpCHQzH-fKiCIbpF6E0YMALzdv6Ssg1OrFib5KRF9waEeXmgGmBTzF5SFwKfR-NnN0odKqNK-ZTtFnsbJ2jOmHFcosBL8RiQsTa36ZPGukIIHKiI7EYhJm2MktBGhuEn5jOp3BuTN0DqHeC0LmocpzGG13SVD11crUl5VUMy7cB5Tvz8H4Q_uuOEFm_yW9wXjNsom-0jXZDtNfaJydhCFvlYRyBe69Inh9q9mQ8pQHw6gNmzVdDDaLxzBGkWNAfvFASVhjbQwzc8ErInJ8e5SIU3yFn1EPKe26BZSLE_5uFyfHuHtmVLnMl-wmlKzsBHyGgEOB7mWLY9owz1B1KTRkqG32g0m8eRYORNGpmO1atllPzriw8Dv7WT1QthEPnPIXiAn82bHOWfE_UzNKZTdk2CoBfjdOfVUlSgtGXhGcJU9BLiWDsucweLIfQbLhWKy1l1ka42-DAKCUn8nuAKMiCOHrD0vhW4zvCbSl9D_Qjey_r1Aa37z3cSMV-1G00)

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

1. [Edit this diagram with plantuml.com](http://www.plantuml.com/plantuml/uml/fLHHRo8t47xdLqnvg8XKG4tpL5NL4U2II4H1MT9xEGaPxm2Z67jhZ-5MLVvxFRkRXJlegT8zmEwEPpv__ZpVV0YiFCUTwVn4LfkO8soPY_3xSEZLOR0XtiPL3EYriuoM1zhjXYhtfEpUn28EnpVzkL6MNnvdGwCO0wVGSfoo5LdqWqAmcTWWZDskC2dAiF1AlwA7bOisLxw4FU6XCqSVdEqLrSEY-GMwvoKlYKithOmieCtxGWtS6dXx0RzxzOwPunwDIyWNCIVlgzsBosrn06Lpk5iy9k3RXdfF7OBG-PJ1dTkFZOjvzmh-wG2q6Lg26xTFQTNh8BqtEG1P6HXto-aN5gIbCglJD31EvVsLCihgHA_PQ3IxJGo-hcvtMQg2le8OpH--a-rTv4gMFtusgaGV_eHZQRqOAbaa21_bJBu4zcgz9Wq1_PuqDlX7JTYjXAlM7dDYnUHikzeU7Q1jazxXS4Z4YrCU5_hb4wvWL1I6T0Kfl9xZgeI4_gp810bCA1G9eRuhxOn1pG7qErQ0NB4Qm6CqJ8L181jOr0tWexLaDyrXtZhoU-lKelNkiscMqEKXksGfCHLdjB7mP3_RnuyZs9E21UsmVwi2va8Kd8Vvmr-WbSy_fwpCHQzH-fKiCIbpF6E0YMALzdv6Ssg1OrFib5KRF9waEeXmgGmBTzF5SFwKfR-NnN0odKqNK-ZTtFnsbJ2jOmHFcosBL8RiQsTa36ZPGukIIHKiI7EYhJm2MktBGhuEn5jOp3BuTN0DqHeC0LmocpzGG13SVD11crUl5VUMy7cB5Tvz8H4Q_uuOEFm_yW9wXjNsom-0jXZDtNfaJydhCFvlYRyBe69Inh9q9mQ8pQHw6gNmzVdDDaLxzBGkWNAfvFASVhjbQwzc8ErInJ8e5SIU3yFn1EPKe26BZSLE_5uFyfHuHtmVLnMl-wmlKzsBHyGgEOB7mWLY9owz1B1KTRkqG32g0m8eRYORNGpmO1atllPzriw8Dv7WT1QthEPnPIXiAn82bHOWfE_UzNKZTdk2CoBfjdOfVUlSgtGXhGcJU9BLiWDsucweLIfQbLhWKy1l1ka42-DAKCUn8nuAKMiCOHrD0vhW4zvCbSl9D_Qjey_r1Aa37z3cSMV-1G00)
1. Copy and paste the final UML into the UML Source section
1. Update the img src and edit link target to the current values

### Notes

* See the help docs for [C4 variant of PlantUML](https://github.com/RicardoNiepel/C4-PlantUML) for syntax help.
