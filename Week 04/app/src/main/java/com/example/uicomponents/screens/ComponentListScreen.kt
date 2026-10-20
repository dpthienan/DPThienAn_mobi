package com.example.uicomponents.screens

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.uicomponents.navigation.Routes

data class ComponentItem(
    val name: String,
    val description: String,
    val route: String
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ComponentListScreen(onComponentClick: (String) -> Unit) {
    val displayComponents = listOf(
        ComponentItem("Text", "Displays text", Routes.TEXT_DETAIL),
        ComponentItem("Image", "Displays an image", Routes.IMAGE_DETAIL),
    )

    val inputComponents = listOf(
        ComponentItem("TextField", "Input field for text", Routes.TEXTFIELD_DETAIL),
        ComponentItem("PasswordField", "Input field for passwords", Routes.PASSWORD_DETAIL),
        ComponentItem("Toggle", "On/off switch", Routes.TOGGLE_DETAIL),
        ComponentItem("Slider", "Selects a value from a range", Routes.SLIDER_DETAIL),
        ComponentItem("DatePicker", "Selects a date and time", Routes.DATEPICKER_DETAIL),
    )

    val layoutComponents = listOf(
        ComponentItem("Column", "Arranges elements vertically", Routes.COLUMN_DETAIL),
        ComponentItem("Row", "Arranges elements horizontally", Routes.ROW_DETAIL),
    )

    val selectionComponents = listOf(
        ComponentItem("Button", "Triggers an action when tapped", Routes.BUTTON_DETAIL),
        ComponentItem("Checkbox", "Selects one or multiple options", Routes.CHECKBOX_DETAIL),
        ComponentItem("RadioButton", "Selects a single option", Routes.RADIOBUTTON_DETAIL),
        ComponentItem("Picker", "Selects a value from a list", Routes.PICKER_DETAIL),
    )

    val navigationComponents = listOf(
        ComponentItem("NavigationView", "Navigation container with title and back button", Routes.NAVIGATIONVIEW_DETAIL),
        ComponentItem("TabBar", "Switches between main sections", Routes.TABBAR_DETAIL),
        ComponentItem("Menu", "Shows a menu with multiple actions", Routes.MENU_DETAIL),
    )

    val contentComponents = listOf(
        ComponentItem("List", "Displays a list of items", Routes.LIST_DETAIL),
        ComponentItem("Card", "Container with content and style", Routes.CARD_DETAIL),
        ComponentItem("Divider", "Separates content into sections", Routes.DIVIDER_DETAIL),
    )

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        text = "UI Components List",
                        color = Color(0xFF2196F3),
                        fontWeight = FontWeight.Bold
                    )
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = Color.White
                )
            )
        }
    ) { innerPadding ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(0.dp)
        ) {
            item { SectionHeader("Display") }
            items(displayComponents.size) { index ->
                ComponentCard(displayComponents[index], onComponentClick)
                Spacer(modifier = Modifier.height(8.dp))
            }

            item {
                Spacer(modifier = Modifier.height(8.dp))
                SectionHeader("Input")
            }
            items(inputComponents.size) { index ->
                ComponentCard(inputComponents[index], onComponentClick)
                Spacer(modifier = Modifier.height(8.dp))
            }

            item {
                Spacer(modifier = Modifier.height(8.dp))
                SectionHeader("Layout")
            }
            items(layoutComponents.size) { index ->
                ComponentCard(layoutComponents[index], onComponentClick)
                Spacer(modifier = Modifier.height(8.dp))
            }

            item {
                Spacer(modifier = Modifier.height(8.dp))
                SectionHeader("Selection")
            }
            items(selectionComponents.size) { index ->
                ComponentCard(selectionComponents[index], onComponentClick)
                Spacer(modifier = Modifier.height(8.dp))
            }

            item {
                Spacer(modifier = Modifier.height(8.dp))
                SectionHeader("Navigation")
            }
            items(navigationComponents.size) { index ->
                ComponentCard(navigationComponents[index], onComponentClick)
                Spacer(modifier = Modifier.height(8.dp))
            }

            item {
                Spacer(modifier = Modifier.height(8.dp))
                SectionHeader("Content")
            }
            items(contentComponents.size) { index ->
                ComponentCard(contentComponents[index], onComponentClick)
                Spacer(modifier = Modifier.height(8.dp))
            }

            item { Spacer(modifier = Modifier.height(16.dp)) }
        }
    }
}

@Composable
private fun SectionHeader(title: String) {
    Text(
        text = title,
        fontSize = 14.sp,
        fontWeight = FontWeight.Normal,
        color = Color.Black,
        modifier = Modifier.padding(vertical = 8.dp)
    )
}

@Composable
private fun ComponentCard(item: ComponentItem, onClick: (String) -> Unit) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onClick(item.route) },
        shape = RoundedCornerShape(8.dp),
        colors = CardDefaults.cardColors(
            containerColor = Color(0xFFBBDEFB)
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 0.dp)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp, vertical = 12.dp)
        ) {
            Text(
                text = item.name,
                fontSize = 15.sp,
                fontWeight = FontWeight.Bold,
                color = Color.Black
            )
            Text(
                text = item.description,
                fontSize = 13.sp,
                color = Color.DarkGray
            )
        }
    }
}
