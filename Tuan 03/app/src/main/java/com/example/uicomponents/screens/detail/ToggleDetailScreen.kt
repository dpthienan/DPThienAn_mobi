package com.example.uicomponents.screens.detail

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ToggleDetailScreen(onBack: () -> Unit) {
    var isNotificationOn by remember { mutableStateOf(true) }
    var isDarkModeOn by remember { mutableStateOf(false) }
    var isLocationOn by remember { mutableStateOf(true) }
    var isBluetoothOn by remember { mutableStateOf(false) }

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        text = "Toggle",
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
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .padding(horizontal = 24.dp, vertical = 16.dp)
        ) {
            Text(
                text = "On/off switch",
                fontSize = 14.sp,
                color = Color.Gray,
                modifier = Modifier.padding(bottom = 16.dp)
            )

            ToggleRow(
                label = "Notifications",
                checked = isNotificationOn,
                onCheckedChange = { isNotificationOn = it }
            )
            HorizontalDivider(color = Color(0xFFEEEEEE))
            ToggleRow(
                label = "Dark Mode",
                checked = isDarkModeOn,
                onCheckedChange = { isDarkModeOn = it }
            )
            HorizontalDivider(color = Color(0xFFEEEEEE))
            ToggleRow(
                label = "Location",
                checked = isLocationOn,
                onCheckedChange = { isLocationOn = it }
            )
            HorizontalDivider(color = Color(0xFFEEEEEE))
            ToggleRow(
                label = "Bluetooth",
                checked = isBluetoothOn,
                onCheckedChange = { isBluetoothOn = it }
            )
        }
    }
}

@Composable
private fun ToggleRow(
    label: String,
    checked: Boolean,
    onCheckedChange: (Boolean) -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 12.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = label,
            fontSize = 16.sp,
            color = Color.Black
        )
        Switch(
            checked = checked,
            onCheckedChange = onCheckedChange,
            colors = SwitchDefaults.colors(
                checkedThumbColor = Color.White,
                checkedTrackColor = Color(0xFF2196F3),
                uncheckedThumbColor = Color.White,
                uncheckedTrackColor = Color.LightGray
            )
        )
    }
}
