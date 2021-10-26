System Boundary Diagram
=======================

![rendered boundary diagram](https://www.plantuml.com/plantuml/png/fLLHRo8t47xdLqnvg8ZKW9fBNwggEW9S4YbHK9RqNav2Nky0epFsrXx3hQhyztgMPQ50JvKg9M36CzzydXb__XXOUOvhq_c1h3QnG5Wnb-7NmS2hRNz9l8fv3EYriuoM-zgj1whmfEp6n38EHhVNKwCilpq_3OnY39nCyr7oLcJHzql1PcA3C7BhqYGhmymh_HKzv2xQGlaADeJRpXHzSBPNrbyMpK_GFGzvIrowQMTe0MrnBTJ0BO1N5_2xLtlC0ZTeN4A-Y3dUxtOlRhV10PGju7xsd83l6kezjGr2vtC6zsupCYuMtIlugmFGUcWnBjqckTNBVbetFW1P5HZNyyat5gIvClcn6nYdYkjS6MLrejSa6ZxT9GOdqViiSrNIFo26qyVlU7iNkIxBRpyQLQ4FlyCXTBSPwhA84Jx9cNm5xDLYGHe2-WrfRF0FDM6N2rUjFHR4YidPThSzEa0x9htjTfk8bySyBipBPynXM9Q6T0qfl5vZNa52VrLaQg9Z2cL2sFLAEsDGSm2znmfGA5PzU8w6gJG8P0DBTGFuQ2tPPVVgbDquxoLkSmdCLS3BCzHi2eMf2xpqMDF9s7aypzyaUU_8_tjdrvdUGpR9KenyrR69ZK78Q6dXnNwnpv-6i245CrhZzPqAM4Wrm7cOFlu1MldYI_BANFGQvLAG9IPb3eKCDSsKkyatcmqVtkvIfhI0XvXtc-LGCss8AtX5xNmHKiGhckERUPZLjR9gYOS3rkSJe5f7u7uo6qnVilJnDXkC9q-JsGHwjxSVhXAcTOpWQRbYwQ0X-xKpD0QqvD3Iu005bgGP2r0U0QtsLIc_jiGhc3rby7F_1g8r608uNg7VKa0GtABVGLlKovfxI_Xyyalllf7q7_-C63ZyD_82UeRLZF7_0cqnJcOkx2P9njeZUy8DXhROh4le_NBxuUOCfPcfVGYC_hrH3OtB02ho2YtBrSC0iP7Xbs4otvpFHnEqGK-B2gYGIAxEYt0vPJkNBUkJYVmEzrQ46jbUe-LvK2h8jNqSZCOmfH8DMMo4w4WLTyzTShmdRgx3oqDsBM-V5oKHGIaGF9Ok43lHiai0SxMRtXO8XZk308gga8qk1dYqZ4k_KyUiLT9tgSNnYzMociRSK5ZL90GgRK18ltitRTltlcT4KjlNnB1oxgjS2bh8SDwBLyiEs8a6mgvAPLEb1lWKyEIv6MDfN0Ng8CwG_aBK6aDOHDE09lY4zwIg-VX4JNRMrqO2QyD7j4LScxy1)

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
System(TTAHUB, "TTA Hub", "TTA Activity Records")
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
Rel(www_app, TTAHUB, "retrieve Activity Record data", "https GET (443)")
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

1. [Edit this diagram with plantuml.com](http://www.plantuml.com/plantuml/uml/fLLHRo8t47xdLqnvg8ZKW9fBNwggEW9S4YbHK9RqNav2Nky0epFsrXx3hQhyztgMPQ50JvKg9M36CzzydXb__XXOUOvhq_c1h3QnG5Wnb-7NmS2hRNz9l8fv3EYriuoM-zgj1whmfEp6n38EHhVNKwCilpq_3OnY39nCyr7oLcJHzql1PcA3C7BhqYGhmymh_HKzv2xQGlaADeJRpXHzSBPNrbyMpK_GFGzvIrowQMTe0MrnBTJ0BO1N5_2xLtlC0ZTeN4A-Y3dUxtOlRhV10PGju7xsd83l6kezjGr2vtC6zsupCYuMtIlugmFGUcWnBjqckTNBVbetFW1P5HZNyyat5gIvClcn6nYdYkjS6MLrejSa6ZxT9GOdqViiSrNIFo26qyVlU7iNkIxBRpyQLQ4FlyCXTBSPwhA84Jx9cNm5xDLYGHe2-WrfRF0FDM6N2rUjFHR4YidPThSzEa0x9htjTfk8bySyBipBPynXM9Q6T0qfl5vZNa52VrLaQg9Z2cL2sFLAEsDGSm2znmfGA5PzU8w6gJG8P0DBTGFuQ2tPPVVgbDquxoLkSmdCLS3BCzHi2eMf2xpqMDF9s7aypzyaUU_8_tjdrvdUGpR9KenyrR69ZK78Q6dXnNwnpv-6i245CrhZzPqAM4Wrm7cOFlu1MldYI_BANFGQvLAG9IPb3eKCDSsKkyatcmqVtkvIfhI0XvXtc-LGCss8AtX5xNmHKiGhckERUPZLjR9gYOS3rkSJe5f7u7uo6qnVilJnDXkC9q-JsGHwjxSVhXAcTOpWQRbYwQ0X-xKpD0QqvD3Iu005bgGP2r0U0QtsLIc_jiGhc3rby7F_1g8r608uNg7VKa0GtABVGLlKovfxI_Xyyalllf7q7_-C63ZyD_82UeRLZF7_0cqnJcOkx2P9njeZUy8DXhROh4le_NBxuUOCfPcfVGYC_hrH3OtB02ho2YtBrSC0iP7Xbs4otvpFHnEqGK-B2gYGIAxEYt0vPJkNBUkJYVmEzrQ46jbUe-LvK2h8jNqSZCOmfH8DMMo4w4WLTyzTShmdRgx3oqDsBM-V5oKHGIaGF9Ok43lHiai0SxMRtXO8XZk308gga8qk1dYqZ4k_KyUiLT9tgSNnYzMociRSK5ZL90GgRK18ltitRTltlcT4KjlNnB1oxgjS2bh8SDwBLyiEs8a6mgvAPLEb1lWKyEIv6MDfN0Ng8CwG_aBK6aDOHDE09lY4zwIg-VX4JNRMrqO2QyD7j4LScxy1)
1. Copy and paste the final UML into the UML Source section
1. Update the img src and edit link target to the current values

### Notes

* See the help docs for [C4 variant of PlantUML](https://github.com/RicardoNiepel/C4-PlantUML) for syntax help.
