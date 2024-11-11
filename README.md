# Autonomous Vehicle Decision Validation with CLIPS & Tictac 6.1

This project aims to validate the decisions made by an autonomous driver based on formalized traffic rules and driving conduct. Using the CLIPS rule-based language and Tictac 6.1 framework, the system simulates various driving scenarios to test and analyze autonomous decision-making. The project consists of implementing scenarios, defining decision rules, and measuring the performance of the autonomous system.

## Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Project Structure](#project-structure)
- [Scenarios](#scenarios)
  - [Test Scenario 1](#test-scenario-1)
  - [Test Scenario 2](#test-scenario-2)
  - [Test Scenario 3](#test-scenario-3)
- [Rules and Decision Logic](#rules-and-decision-logic)
- [Performance Measurement](#performance-measurement)
- [Contributors](#contributors)
- [License](#license)

## Overview

The primary goal of this project is to validate the decision-making of an autonomous driver in specific scenarios based on traffic rules and driving etiquette. The system simulates a sequence of frames where various objects and relationships are defined to replicate realistic driving environments. For each scenario, decisions are processed by CLIPS and Tictac 6.1 to determine how an autonomous vehicle should respond. This includes testing performance with specific time measurements.

## Getting Started

To run this project, you'll need to install CLIPS and Tictac 6.1. Additionally, testing the decision-making requires setting up the scenarios and ensuring the facts and rules are compatible with Tictac 6.1’s requirements.

### Prerequisites

- [CLIPS 6.4.1](https://sourceforge.net/projects/clipsrules/files/CLIPS/6.4.1)
- [Tictac 6.1](https://tictac.com) (confirm access and setup instructions as necessary)
- Spreadsheet software to open and edit `MedieStandDev.xlsx` for measuring performance (e.g., Microsoft Excel, Google Sheets)

### Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/yourprojectname.git
    cd yourprojectname
    ```

2. Install CLIPS and set up Tictac 6.1 according to the documentation provided by each platform. Ensure that CLIPS and Tictac 6.1 are properly configured in your environment.

3. Verify the setup by running a basic CLIPS session with a test rule to confirm functionality.

## Project Structure

```
├── perceptiiTest05/                # Scenario definitions and data files
│   ├── t1.clp
│   ├── t2.clp
│   ├── t3.clp
│   ├── t4.clp
│   ├── t5.clp
│   ├── t6.clp
│   └── t7.clp
├── go
├── maneuverValidityASK.clp
├── PERCEPT-MANAGER.clp
├── AddMomentBeliefsGetStartTime.clp
├── headers.clp               # Header file to set up configuration switches and variables
├── initials.clp
├── MAIN-rules.clp
├── DRIVER-AGENT.clp           # Core driver logic for running scenarios
├── MedieStandDev.xlsx        # Spreadsheet for calculating mean and standard deviation
├── [Documentation] SE-Driver-Framework.pdf        # Project documentation, but PDF
└── README.md                 # Project documentation
```

## Scenarios

### Test Scenario 1

**Description**: A scenario simulating a vehicle approaching a pedestrian crossing.

- **Objects**: `vehicle`, `pedestrian`, `crosswalk`
- **Relations**: `vehicle-approaches-crosswalk`, `pedestrian-on-crosswalk`
- **Perception Methods**: Pedestrian detection using computer vision (reference paper [link or description])

### Test Scenario 2

**Description**: A scenario where the vehicle encounters an intersection with a stop sign.

- **Objects**: `vehicle`, `stop-sign`, `intersection`
- **Relations**: `vehicle-approaches-intersection`, `stop-sign-visible`
- **Perception Methods**: Sign recognition through computer vision (reference paper [link or description])

### Test Scenario 3

**Description**: A scenario where the vehicle approaches another vehicle on the highway, simulating lane-change or overtaking.

- **Objects**: `vehicle`, `other-vehicle`, `lane-markings`
- **Relations**: `vehicle-approaches-other-vehicle`, `lane-change-available`
- **Perception Methods**: Lane detection and vehicle tracking (reference paper [link or description])

## Rules and Decision Logic

Rules are written in CLIPS and designed to dictate the autonomous vehicle’s response in each scenario based on the objects, relationships, and scenarios defined.

Each rule is structured as follows:

```clips
(defrule scenario1-decision
  (vehicle (state approaching-crosswalk))
  (pedestrian (position on-crosswalk))
  =>
  (assert (vehicle (action stop)))
)
```

Adapt these rules according to the logic required for each scenario. For testing, rules are executed within the DriverAgent environment.

## Performance Measurement

1. Activate time measurement by setting the switch `?*ag-measure-time*` to `TRUE` in `headers.clp`.
2. Run each scenario multiple times (recommended: 5) to record execution time.
3. Use the `MedieStandDev.xlsx` spreadsheet to calculate mean and standard deviation for each scenario execution time.
4. Record and analyze the performance metrics to assess system efficiency and identify any bottlenecks.

## Contributors

- [Vlad Bartolomei](https://github.com/vladbarto)
- [Cătălina Cojocaru](https://github.com/cojocarucatalina)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
