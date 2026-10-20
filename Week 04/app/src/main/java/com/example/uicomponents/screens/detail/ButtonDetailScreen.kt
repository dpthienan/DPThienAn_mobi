package com.example.uicomponents.screens.detail

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
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
fun ButtonDetailScreen(onBack: () -> Unit) {
    var clickCount by remember { mutableIntStateOf(0) }
    var lastAction by remember { mutableStateOf("") }

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        text = "Button",
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
                .padding(horizontal = 24.dp)
                .verticalScroll(rememberScrollState()),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Spacer(modifier = Modifier.height(8.dp))

            if (lastAction.isNotEmpty()) {
                Text(
                    text = lastAction,
                    fontSize = 14.sp,
                    color = Color(0xFF2196F3)
                )
            }

            // Filled Button
            Button(
                onClick = {
                    clickCount++
                    lastAction = "Filled Button clicked ($clickCount)"
                },
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(8.dp),
                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF2196F3))
            ) {
                Text("Filled Button", color = Color.White)
            }

            // Outlined Button
            OutlinedButton(
                onClick = { lastAction = "Outlined Button clicked" },
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(8.dp)
            ) {
                Text("Outlined Button", color = Color(0xFF2196F3))
            }

            // Text Button
            TextButton(
                onClick = { lastAction = "Text Button clicked" },
                modifier = Modifier.fillMaxWidth()
            ) {
                Text("Text Button", color = Color(0xFF2196F3))
            }

            // Elevated Button
            ElevatedButton(
                onClick = { lastAction = "Elevated Button clicked" },
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(8.dp)
            ) {
                Text("Elevated Button")
            }

            // Disabled Button
            Button(
                onClick = {},
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(8.dp),
                enabled = false
            ) {
                Text("Disabled Button")
            }
        }
    }
}
