
[![CI-iOS](https://github.com/abdahad1996/Img.ly/actions/workflows/ios.yml/badge.svg)](https://github.com/abdahad1996/Img.lyactions/workflows/ios.yml)


# Img.ly
💡 My Motivation for this project was to create a pure SwiftUI+Async/Await based hierarchical tree structure app that consumes a hierarchical json following Solid Principles,Clean Architecture and Testability. I think of the design in a critical and scalable way backed by tests which was very fun to do.

# Code Coverage
<img width="1161" alt="Screenshot 2024-03-26 at 12 46 34 PM" src="https://github.com/abdahad1996/Img.ly/assets/28492677/9340e6e0-5059-4934-a4ca-8f9203668234">

# SUMMARY
` This project has a Core Framework responsible for providing data to the UI for consumption. The folder structure is as below . For more Details go to the Architecture section.`

<img width="229" alt="Screenshot 2024-03-26 at 12 57 09 PM" src="https://github.com/abdahad1996/Img.ly/assets/28492677/994c79cd-6107-428c-9f76-53a19eae5b13">

# DETAIL
1. [Installation Guide](#installation-guide)
2. [Demo Screenshots](./IMGLY/Readme_Sections/Demo_Videos/Demo_Videos.md#demo-videos)
3. [Requirements](#Requirements)
4. [Tools](#tools)
5. [Frameworks](#frameworks)
6. [Concepts](#concepts)
7. [Architecture](./IMGLY/Readme_Sections/Architecture/Architecture.md#architecture)
    1. [Overview](./IMGLY/Readme_Sections/Architecture/Architecture.md#overview)
    2. [Domain](./IMGLY/Readme_Sections/Architecture/Architecture.md#domain)
    3. [Api](./IMGLY/Readme_Sections/Architecture/Architecture.md#api)
    4. [Persistence](./IMGLY/Readme_Sections/Architecture/Architecture.md#infra)
    5. [Presentation](./IMGLY/Readme_Sections/Architecture/Architecture.md#presentation)
    6. [UI](./IMGLY/Readme_Sections/Architecture/Architecture.md#ui)
    7. [Main](./IMGLY/Readme_Sections/Architecture/Architecture.md#main)
8. [Testing Strategy](./IMGLY/Readme_Sections/Testing_Strategy/Testing_Strategy.md#testing-strategy)
    1. [Unit Tests](./IMGLY/Readme_Sections/Testing_Strategy/Testing_Strategy.md#unit-tests)
    2. [Integration Tests](./IMGLY/Readme_Sections/Testing_Strategy/Testing_Strategy.md#integration-tests)
        1. [End-to-End Tests](./IMGLY/Readme_Sections/Testing_Strategy/Testing_Strategy.md#end-to-end-tests)
    3. [Snapshot Tests](./IMGLY/Readme_Sections/Testing_Strategy/Testing_Strategy.md#snapshot-tests)
9. [DesignSystem](#DesignTheme)
10. [References](#References)
    
   


## Installation Guide

### 1. Setup `Img.ly` 
- clone the project from the main branch and run the simulator.
### 2. Validate the setup
Test that everything is wired up correctly by running tests for `CI_IOS` targets to validate that all tests pass.

## Tools
- ✅ Xcode 16.0
- ✅ swift-driver version: 1.90.11.1 Apple Swift version 5.10 (swiftlang-5.10.0.13 clang-1500.3.9.4)

## Frameworks
- ✅ SwiftUI
- ✅ Async/Await
- ✅ Combine
- ✅ No third party

## Concepts
- ✅ MVVM, Clean Architecture
- ✅ Modular Design
- ✅ SOLID Principles
- ✅ TDD, Unit Testing, Integration Testing, Snapshot Testing, and UI Testing using Page Object Pattern
- ✅ Dependency injection and Dependency Inversion
- ✅ Composition Root, Decorator Patterns, Composite Pattern, Command Query Separation, Adapter Pattern
- ✅ Domain-Driven Design

## Requirements

Please solve the following tasks with this kind of data format. Of course, your solution should work with any data in the same format.

1.✅  **Fetch and display the data**. 
Your first task is to fetch the data from [`https://ubique.img.ly/frontend-tha/data.json`](https://ubique.img.ly/frontend-tha/data.json) and display it in a navigation hierarchy in your app.

2.✅  **Interact with the data**.
Add interaction to the tree. Allow removing and moving children in the list by enabling the edit mode.

3.✅  **Fetch additional data.**
If the user clicks on a leaf, fetch data from `https://ubique.img.ly/frontend-tha/entries/${id}.json` (where `${id}` is the id of an entry). Display the data in a detail view on a new screen. Beware that some data might not exist (404 status code).

4.✅  **Add theming**
Add the ability to easily change the theme of your UI to a different customized set of colors.

5.✅  **Polish the design**
Tweak the overview and detail screens to be aesthetically pleasing. Feel free to make it reflect your personal taste in user interface design.

### Payload contract

```
GET /data.json

200 RESPONSE

[
  {
    "label": "img.ly",
    "children": [
      {
        "label": "Workspace A",
        "children": [
          { "id": "imgly.A.1", "label": "Entry 1" },
          { "id": "imgly.A.2", "label": "Entry 2" },
          { "id": "imgly.A.3", "label": "Entry 3" }
        ]
      },
      {
        "label": "Workspace B",
        "children": [
          { "id": "imgly.B.1", "label": "Entry 1" },
          { "id": "imgly.B.2", "label": "Entry 2" },
          {
            "label": "Entry 3",
            "children": [
              {
                "id": "imgly.B.3.1",
                "label": "Sub-Entry 1"
              }
            ]
          }
        ]
      }
    ]
  },
  {
    "label": "9elements",
    "children": [
      {
        "label": "Workspace A",
        "children": [
          {
            "id": "9e.A.1",
            "label": "Entry 1"
          },
          {
            "id": "9e.A.2",
            "label": "Entry 2"
          }
        ]
      }
    ]
  }
]

```

---

```
GET /entries/${id}.json

200 RESPONSE
{
		"id": "25359599-ba54-5132-8309-97c8513e08e9",
		"createdAt": "2082-09-12T06:43:47.099Z",
		"createdBy": "du@ijdu.cm",
		"lastModifiedAt": "2023-08-31T07:07:40.646Z",
		"lastModifiedBy": "pit@gon.bw",
		"description": "Duw orevoza jiprudis faz alnaimu sazafapa cuwpe zifehe kowo wasmag otu tuwulfoj bifo se botirgo. Kiojka roftan otecu ohukdu zuaruuze ow ko jogapob naw jadkawwa nem vo fasoz tofih vu oz hizjorguc maj. Kedfov kikodu lan afavo ehonaki be nem du sudomaew mohe vohicemu vultuob muhbacni suzfef ihidozep azitude tilre hubju. Ovdunir ozu melnutvu ti fudolwe ohtet bicun tirat honwajak ujnu ak pelbod cuw coez cu aha. Icuru faabupuf la tu vegelu cinak wuoh hulico nen ri mub cedal sir hakeje guaja supbad togju jolug. Res ipemte bovzahle ih tus hi mopeczaj fahahal ejaha cibvi kene ti gele romi ufpiki lihkefju jol. Perum vudfen micbibo tueku seab nobjeolu keden elgeiv he efoas woz kusfop lirfidu."
	}

```

---

## DesignTheme
I used the concept of Atomic design to create tokens for colors, fonts, and miscellaneous items together with polymorphism I was able to create different implementations of the combined token and I only had to change the dependency to change the theme of the app.

<img width="583" alt="Screenshot 2024-03-26 at 3 20 00 PM" src="https://github.com/abdahad1996/Img.ly/assets/28492677/c4680c56-1b1a-495e-abf9-497001feb5a0">

## References

1. [The iOS Lead Essential Program](https://iosacademy.essentialdeveloper.com/p/ios-lead-essentials/)
2. [Clean Architecture](https://www.goodreads.com/book/show/18043011-clean-architecture?ac=1&from_search=true&qid=cebbBLQz86&rank=1) by Robert C. Martin
3. [Clean Code: A Handbook of Agile Software Craftsmanship](https://www.goodreads.com/book/show/3735293-clean-code?from_search=true&from_srp=true&qid=0lfCKDxK4E&rank=1) by Robert C. Martin
4. [Dependency Injection Principles, Practices, and Patterns](https://www.goodreads.com/book/show/44416307-dependency-injection-principles-practices-and-patterns?ref=nav_sb_ss_1_27) by Mark Seemann and Steven van Deursen
5. [Domain-Driven Design: Tackling Complexity in the Heart of Software](https://www.goodreads.com/book/show/179133.Domain_Driven_Design?ref=nav_sb_noss_l_16)
6. [Design It! : Pragmatic Programmers: From Programmer to Software Architect](https://www.goodreads.com/book/show/31670678-design-it?from_search=true&from_srp=true&qid=Nm98t342VP&rank=6) by Michael Keeling
g


