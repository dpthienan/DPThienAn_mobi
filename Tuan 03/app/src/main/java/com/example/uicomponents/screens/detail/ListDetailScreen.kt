package com.example.uicomponents.screens.detail

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.KeyboardArrowRight
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

data class ListItem(
    val title: String,
    val subtitle: String,
    val initial: String
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ListDetailScreen(onBack: () -> Unit) {
    val items = listOf(
        ListItem("Text", "Displays text content", "T"),
        ListItem("Image", "Displays an image", "I"),
        ListItem("TextField", "Input field for text", "TF"),
        ListItem("Button", "Triggers an action", "B"),
        ListItem("Checkbox", "Select multiple options", "CB"),
        ListItem("RadioButton", "Select a single option", "RB"),
        ListItem("Slider", "Select a value from range", "SL"),
        ListItem("Toggle", "On/off switch", "TG"),
        ListItem("Card", "Container with style", "CA"),
        ListItem("Row", "Horizontal layout", "RW"),
        ListItem("Column", "Vertical layout", "CL"),
    )

    val avatarColors = listOf(
        Color(0xFF2196F3), Color(0xFF4CAF50), Color(0xFFFF9800),
        Color(0xFF9C27B0), Color(0xFFF44336), Color(0xFF00BCD4),
        Color(0xFF795548), Color(0xFF607D8B), Color(0xFF3F51B5),
        Color(0xFF009688), Color(0xFFE91E63),
    )

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        text = "List",
                        color = Color(0xFF2196F3),
                        fontWeight = FontWeight.Bold
                    )
                },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "Back",
                            tint = Color(0xFF2196F3)
                        )
                    }
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
        ) {
            itemsIndexed(items) { index, item ->
                ListItemRow(
                    item = item,
                    color = avatarColors[index % avatarColors.size]
                )
                if (index < items.size - 1) {
                    HorizontalDivider(
                        modifier = Modifier.padding(horizontal = 16.dp),
                        color = Color(0xFFEEEEEE)
                    )
                }
            }
        }
    }
}

@Composable
private fun ListItemRow(item: ListItem, color: Color) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Avatar circle
        Surface(
            modifier = Modifier
                .size(44.dp)
                .clip(CircleShape),
            color = color
        ) {
            Box(contentAlignment = Alignment.Center) {
                Text(
                    text = item.initial,
                    color = Color.White,
                    fontWeight = FontWeight.Bold,
                    fontSize = 14.sp
                )
            }
        }

        Spacer(modifier = Modifier.width(16.dp))

        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = item.title,
                fontSize = 15.sp,
                fontWeight = FontWeight.Medium,
                color = Color.Black
            )
            Text(
                text = item.subtitle,
                fontSize = 13.sp,
                color = Color.Gray
            )
        }

        Icon(
            imageVector = Icons.AutoMirrored.Filled.KeyboardArrowRight,
            contentDescription = null,
            tint = Color.LightGray,
            modifier = Modifier.size(20.dp)
        )
    }
}
