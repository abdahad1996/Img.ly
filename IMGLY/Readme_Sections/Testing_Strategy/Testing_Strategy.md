## Testing Strategy
<img width="1080" alt="Screenshot 2024-01-16 at 08 52 19" src="https://github.com/abdahad1996/WorldOfPAYBACK/assets/28492677/ea9d13d2-dbb1-4eb2-a8f6-b9faaa0ad739">
<img width="1067" alt="Screenshot 2024-01-16 at 08 52 05" src="https://github.com/abdahad1996/WorldOfPAYBACK/assets/28492677/58c1112b-288c-4319-acec-e55e4b8d26a1">

I tried following the testing pyramid strategy. The foundation for my testing strategy was unit tests for the system internals (without hitting external systems like the network). In addition, I used snapshot tests to validate the screen layout. Lastly, to test out the whole flow I used UI Tests with page object architecture. 

### Summary Table

### Methodology

I adopted the following naming convention for all tests: test_methodName_expectedOutputWhenGivenInput.

To ensure there was no temporal coupling between tests and prevent artifacts from being left on the disk or in memory, I enabled test randomization for all targets 

### Unit Tests

I based my testing pyramid's foundation on unit tests because they are the most reliable and cost-effective to write. Also, I can easily test each component in isolation by mocking collaborators without making any assumptions about the rest of the system.

### Integration Tests

Furthermore, I tested my json mapping logic in integration.

### Snapshot Tests

Initially, I wrote snapshot tests to verify the UI layout for each state by directly injecting the state in the viewModels. Afterwards, I used them to test-drive new screens as a feedback mechanism alongside with preview. It seemed like a better alternative because they are relatively fast to run, and I could check the UI for both light and dark modes and different design strategies simultaneously.

Nevertheless, I didn't test any logic with snapshot tests as all the logic was encapsulated within the already unit-tested view models.
