Logical Data Model
==================

<img src="http://www.plantuml.com/plantuml/png/VOy_JmCn34VtV8hVXiJ6YgggAojYZzoBkLhaJsJxg2h4ToSNHb2dIE-zsFB9dDItaeCjb1bF8Jo0FfiaT6tdpCLm5R-0wfevOT5sDRmpUx0FgPsK2h9KzbjdDFLB2s79P8ONiutVd5wv3uwl03n24fvnbbMgut1OkRAISpeUV-t-9Sx6NAMkaxfJr3aa9h6UwNOd-QFcWJ6Hy-3xC-cYlE-Dv8Ew51vPwLDjFVsdliE9QzfA_W40" alt="logical data model diagram">

UML Source
----------

```
@startuml
scale 1

' avoid problems with angled crows feet
skinparam linetype ortho

class IssueTtaReport {
  * id : bigint <<generated>>
  * issue_id : string
  * tta_report_display_id : string
  * tta_report_id : string
  * start_date : date
  * created_at : timestamp
  * updated_at : timestamp
}
@enduml
```

Instructions
------------

1. [Edit this diagram with plantuml.com](http://www.plantuml.com/plantuml/uml/VOy_JmCn34VtV8hVXiJ6YgggAojYZzoBkLhaJsJxg2h4ToSNHb2dIE-zsFB9dDItaeCjb1bF8Jo0FfiaT6tdpCLm5R-0wfevOT5sDRmpUx0FgPsK2h9KzbjdDFLB2s79P8ONiutVd5wv3uwl03n24fvnbbMgut1OkRAISpeUV-t-9Sx6NAMkaxfJr3aa9h6UwNOd-QFcWJ6Hy-3xC-cYlE-Dv8Ew51vPwLDjFVsdliE9QzfA_W40)
2. Copy and paste the final UML into the UML Source section
3. Update the img src and edit link target to the current values

### Notes

* See the help docs for [Entity Relationship Diagram](https://plantuml.com/ie-diagram) and [Class Diagram](https://plantuml.com/class-diagram) for syntax help.
* We're using the `*` visibility modifier to denote fields that cannot be `null`.
