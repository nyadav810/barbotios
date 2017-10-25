# BarBot Mobile Application

![Menu](https://raw.githubusercontent.com/nyadav810/barbotios/master/barbot/screenshots/Menu.png)
![Recipe Detail](https://raw.githubusercontent.com/nyadav810/barbotios/master/barbot/screenshots/RecipeDetail.png)

## Drink Flow

### 1. Open WebSocket with the Web Server
  - Send query to retrieve all recipes and ingredients for barbot with barbotID

### 2. MenuCollectionViewController (TODO)
  - Displays drinks with images in a grid-like view

### 3. MenuTableViewController
  - Display all recipes for barbot in table view
  - Display search bar for recipes by name - hidden under navigation bar
  - Add new custom drink button - prompts user to enter name

### 4. RecipeViewController
  - User selects drink
    1. Send query to retrieve recipe for drink with recipeID
    2. Display Image
    3. Populate Ingredients Table
    4. User modifies ingredients: Custom order made and temporarily stored in database (flagged as 'custom’)
    5. Select size: short (8oz) or tall (16oz)
    6. Select ice or no ice
  - Custom "Make your own" drink
    1. Add ingredients / quantity in table view
  - User places drink order
    1. Send command with recipeID or custom recipe JSON to server over WebSocket
    2. Receive reply with drink_order uid

### 5. ConfirmOrderViewController (TODO)
  - Present order details to user, including price

### 6. PourViewController
  - When Web Server sends message that barbot is to ready to pour, pour option becomes available
  - To pour, send drink_order uid
  - If not available, prompts user to move to the barbot (show distance with LRB) (TODO)
  - Also have prompt greyed out till available
  - App listens for SRB packet w/ same barbot ID as the selected ordered one (TODO)
  - When user is in range, query server periodically (every second) to check if barbot is ready to pour (if there isn’t a glass there and it’s not actively pouring) (TODO)
  - Thank user for order - UIAlertView
  - Return to drinks menu for current barbot
