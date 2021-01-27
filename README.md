# RecipeBoss
An simple recipe finder iOS app built using MVVM pattern,  clean code,  and unit testing coverage and best practices used in modern iOS programming using `Swift`.

### App Goal:
 - Showing a list of recipes from a source
 - Showing them in grid layout in landscape mode
 - On device orientation change, show a different view with more detail of the recipe but within same container
 - Used same collection view cell dynamically using size class to detect device rotation to support both layout
 - Used `UICollectionViewCompositionalLayout` in iOS13+
 - Used `Combine` for reactiving binding
 - Load images of the recipes separately and fetch the data incrementally as user scrolls though to manage network bandwidth better
 
 ![](/Screenshots/lanscape_mode.png "")
 ![](/Screenshots/potrait_mode.png "")
 ![](/Screenshots/rotation_change.png "")
 

 
 #### JSON Data Source:
 The data for the recipes stays in local `JSON` file. But it can be loaded from a remote source url using http `GET`  if needed. Full support for network layer has been added with potential custom error handling. See usage in view model on error outcome in loading.
 
 At this stage the app points to the local JSON data source. See tech note of the `ApplicationComponentsFactory` and how dependency injection works there.

     /// TODO: Here is the glue. Use `defaultProvider` when real network loading is needed
     /// For now leaded locally from a JSON file
     networkService: ServicesProvider.localStubbedProvider().network
  
  ### Custom Error handling
- See view model logic of error handling & empty state handling
- `Placeholder` view is created to achciev these two cases using same view
  ![](/Screenshots/error_state.png "")
  ![](/Screenshots/empty_state.png "")
  


### 3rd Party Libraries (only in unit testing)
 - `Quick` - To unit test as much as possible 🤫
 - `Nimble` - To pair with Quick 👬
 
 ### Apple frameworks
  `Combine` – To do reactive binding when needed 🤫
  `UIKit` – To build as usual everywhere 😀
  
### Clean MVVM Architecture

- `ViewController` talks to `ViewModel` which relies on `UseCase` under its layer
- The `ViewModel` processes lower level domain models of recipes and converts into higher level `RecipeViewModel` items for the need of the UI
- `ViewModel` take helps from `Transformer` 
- Accessbility ID, label, hints, traits etc calculation and any other formatting etc. is done via the `Transformer`
- `ViewModel` and  `Transformer` are individually unit tested
- There is some support for `Routing` to show how it can be achieved through `FlowCoordinator` pattern
- Some glue code left with some tech notes how the recipe cell tapping and detail view navigation can be done in future

### Dependency Injection
- `ApplicationComponentsFactory` helps in DI and pick the service injection that is need
- Other layers of the app in domain and data level everything is `protocol` driven to achieve loose coupling and DI based unit testing.
- See unit tests at each layer

### Code Organisation / Layers / Grouping
Folder / Grouping are done as per below:
Project has 2 targets: 
 - RecipeBoss - The main code
 - RecipeBossTest - Unit testing of all layers using Quick/Nimble
 
 Codebase has 3 layers: 
  - PresentationLayer
  - DomainLayer
  - DataLayer
  
  ### Accessibility
   - Custom accessibility to each element is supported
   - Accessibility identifiers are injected to each element to help support `UI Automation Testing`
   - See Transformer logic to see acessibility computations
   - `TODO` more work is needed after supporting paginated carousel support. Perhaps full cell should be one accessibility element with some children inside as well.
   ![](/Screenshots/accessibility-1 "")
   ![](/Screenshots/accessibility-2 "")
   ![](/Screenshots/accessibility-3 "")
   ![](/Screenshots/accessibility-4 "")
   
   
   ### Custom Theme
   - Coming up next ...
   - All colours can be used from a central Theme provider helper that would support dynamic colour switching
   - Custom font can also used
   - See some usage in my other repos [here] (https://github.com/arinjoy/MyBank/blob/master/MyBank/PresentationLayer/Shared/Theme/Theme.swift)

   
   

 


