Logical Data Model
==================

<img src="http://www.plantuml.com/plantuml/png/jO-_IWH13CRxUOfqWfsj7CUr5ZQ7_P3RYNl1cSoGP6yvn7TtTgn4iP6h0h_l3_aEvgY-b1nimapm4C8TuALoWgRrbAaOhEndG9ap9PYqhWQlH1xiZQMXOe7CGdvj15NzN4EOCfh1azb2prNOgxBCHxemhV0U0EwXrp_2YMSMXzrk9Y55fxJVVwbRCWwF-POTL4V13pm6nDJZdMzdq4bfAupedJeNwhRIXhIqz9lqyUtl5ySZjRxd7m-xOzHH4XDRotZzmtB3NGUIj9Jy2G00" alt="logical data model diagram">

UML Source
----------

```
@startuml
scale 1

' avoid problems with angled crows feet
skinparam linetype ortho

class IssueMonitoringReview {
  * id : bigint <<generated>>
  * issue_id : string
  * review_id : string
  * start_date : date
  * created_at : timestamp
  * updated_at : timestamp
}

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

1. [Edit this diagram with plantuml.com](http://www.plantuml.com/plantuml/uml/jO-_IWH13CRxUOfqWfsj7CUr5ZQ7_P3RYNl1cSoGP6yvn7TtTgn4iP6h0h_l3_aEvgY-b1nimapm4C8TuALoWgRrbAaOhEndG9ap9PYqhWQlH1xiZQMXOe7CGdvj15NzN4EOCfh1azb2prNOgxBCHxemhV0U0EwXrp_2YMSMXzrk9Y55fxJVVwbRCWwF-POTL4V13pm6nDJZdMzdq4bfAupedJeNwhRIXhIqz9lqyUtl5ySZjRxd7m-xOzHH4XDRotZzmtB3NGUIj9Jy2G00)
2. Copy and paste the final UML into the UML Source section
3. Update the img src and edit link target to the current values

### Notes

* See the help docs for [Entity Relationship Diagram](https://plantuml.com/ie-diagram) and [Class Diagram](https://plantuml.com/class-diagram) for syntax help.
* We're using the `*` visibility modifier to denote fields that cannot be `null`.
