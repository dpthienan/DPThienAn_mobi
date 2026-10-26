package com.example.uthtodo.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.material3.Text
import androidx.compose.material3.Icon
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.uthtodo.data.AppDataProvider
import com.example.uthtodo.model.Task
import com.example.uthtodo.ui.components.AppLogoHeader
import com.example.uthtodo.ui.theme.PurpleLight
import com.example.uthtodo.ui.theme.PurplePrimary
import com.example.uthtodo.ui.theme.PurpleSoft
import com.example.uthtodo.ui.theme.TextPrimary
import com.example.uthtodo.ui.theme.TextSecondary
import com.example.uthtodo.ui.theme.White

@Composable
fun HomeScreen() {
    val appInfo = AppDataProvider.appInfo
    var tasks by remember { mutableStateOf(AppDataProvider.sampleTasks) }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .statusBarsPadding()
            .padding(horizontal = 24.dp)
    ) {
        AppLogoHeader(appName = appInfo.name)

        Spacer(modifier = Modifier.height(8.dp))

        Text(
            text = "Việc hôm nay",
            fontSize = 22.sp,
            fontWeight = FontWeight.Bold,
            color = TextPrimary
        )

        Text(
            text = appInfo.tagline,
            fontSize = 13.sp,
            color = TextSecondary,
            modifier = Modifier.padding(top = 4.dp, bottom = 16.dp)
        )

        LazyColumn(
            verticalArrangement = Arrangement.spacedBy(12.dp),
            modifier = Modifier.fillMaxSize()
        ) {
            items(tasks, key = { it.id }) { task ->
                TaskItem(
                    task = task,
                    onToggle = {
                        tasks = tasks.map { item ->
                            if (item.id == task.id) item.toggle() else item
                        }
                    }
                )
            }
            item { Spacer(modifier = Modifier.height(24.dp)) }
        }
    }
}

@Composable
private fun TaskItem(
    task: Task,
    onToggle: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(PurpleSoft)
            .clickable(onClick = onToggle)
            .padding(16.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(
            modifier = Modifier
                .size(28.dp)
                .background(
                    if (task.isCompleted) PurplePrimary else PurpleLight,
                    CircleShape
                ),
            contentAlignment = Alignment.Center
        ) {
            if (task.isCompleted) {
                Icon(
                    imageVector = Icons.Filled.Check,
                    contentDescription = null,
                    tint = White,
                    modifier = Modifier.size(16.dp)
                )
            }
        }

        Spacer(modifier = Modifier.width(14.dp))

        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = task.title,
                fontSize = 16.sp,
                fontWeight = FontWeight.SemiBold,
                color = if (task.isCompleted) TextSecondary else TextPrimary,
                textDecoration = if (task.isCompleted) {
                    TextDecoration.LineThrough
                } else {
                    TextDecoration.None
                }
            )
            Spacer(modifier = Modifier.height(4.dp))
            Text(
                text = buildString {
                    append(task.category.label)
                    task.dueTime?.let { append(" · $it") }
                },
                fontSize = 13.sp,
                color = TextSecondary
            )
        }
    }
}
