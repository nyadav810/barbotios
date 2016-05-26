# Barbot iOS 9.0 Mobile Application
## Drink Flow
	### Open WebSocket with the Web Server
		- Send query to retrieve all recipes and ingredients for barbot with barbotID
	### MenuCollectionViewController (TODO)
		- Displays drinks with images in a grid-like view
		- Search
		- Custom Drink
	### MenuTableViewController
		- Display all recipes for barbot in table view
		- Display search bar for recipes by name - hidden under navigation bar
		- Add new custom drink button - prompts user to enter name
	### RecipeViewController
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
	### ConfirmOrderViewController (TODO)
		- Present order details to user, including price
	### PourViewController
		- When app picks up short-range beacon (SRB), and barbot is to ready to pour, pour option becomes available
		- To pour, send drink_order uid
		- If not available, prompts user to move to the barbot (show distance with LRB(?))
		- Also have prompt greyed out till available
		- App listens for SRB packet w/ same barbot ID as the selected ordered one
		- When user is in range, query server periodically (every second) to check if barbot is ready to pour (if there isn’t a glass there and it’s not actively pouring)
		- Thank user for order - UIAlertView
		- Return to drinks menu for current barbot