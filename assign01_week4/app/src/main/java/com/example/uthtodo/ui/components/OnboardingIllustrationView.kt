package com.example.uthtodo.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.outlined.Notifications
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.uthtodo.model.OnboardingIllustration
import com.example.uthtodo.ui.theme.PurpleLight
import com.example.uthtodo.ui.theme.PurplePrimary
import com.example.uthtodo.ui.theme.PurpleSoft
import com.example.uthtodo.ui.theme.TextPrimary
import com.example.uthtodo.ui.theme.TextSecondary
import com.example.uthtodo.ui.theme.White

@Composable
fun OnboardingIllustrationView(
    type: OnboardingIllustration,
    modifier: Modifier = Modifier
) {
    Box(
        modifier = modifier
            .fillMaxWidth()
            .height(220.dp)
            .clip(RoundedCornerShape(24.dp))
            .background(PurpleSoft)
            .padding(24.dp),
        contentAlignment = Alignment.Center
    ) {
        when (type) {
            OnboardingIllustration.CHECKLIST -> ChecklistCard()
            OnboardingIllustration.CATEGORIES -> CategoriesCard()
            OnboardingIllustration.REMINDER -> ReminderCard()
        }
    }
}

// UI 2 — Checklist: card trắng với 3 dòng task (1 đã tick)
@Composable
private fun ChecklistCard() {
    Column(
        modifier = Modifier
            .fillMaxWidth(0.85f)
            .background(White, RoundedCornerShape(16.dp))
            .padding(horizontal = 16.dp, vertical = 14.dp),
        verticalArrangement = Arrangement.spacedBy(14.dp)
    ) {
        ChecklistRow(done = true)
        ChecklistRow(done = false)
        ChecklistRow(done = false)
    }
}

@Composable
private fun ChecklistRow(done: Boolean) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        modifier = Modifier.fillMaxWidth()
    ) {
        // Circle checkbox
        Box(
            modifier = Modifier
                .size(22.dp)
                .background(
                    if (done) PurplePrimary else PurpleLight,
                    CircleShape
                ),
            contentAlignment = Alignment.Center
        ) {
            if (done) {
                Icon(
                    imageVector = Icons.Filled.Check,
                    contentDescription = null,
                    tint = White,
                    modifier = Modifier.size(13.dp)
                )
            }
        }
        Spacer(modifier = Modifier.width(12.dp))
        // Line placeholder
        Box(
            modifier = Modifier
                .height(10.dp)
                .fillMaxWidth(if (done) 0.75f else 0.6f)
                .clip(RoundedCornerShape(5.dp))
                .background(PurpleLight)
        )
    }
}

// UI 3 — Categories: 2 card trắng xếp dọc, mỗi card có chip tag label
@Composable
private fun CategoriesCard() {
    Column(
        modifier = Modifier.fillMaxWidth(0.85f),
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        CategoryRow(label = "Học tập", chipColor = PurpleLight, chipTextColor = PurplePrimary)
        CategoryRow(label = "Cuộc sống", chipColor = androidx.compose.ui.graphics.Color(0xFFFFF3E0), chipTextColor = androidx.compose.ui.graphics.Color(0xFFE65100))
    }
}

@Composable
private fun CategoryRow(
    label: String,
    chipColor: androidx.compose.ui.graphics.Color,
    chipTextColor: androidx.compose.ui.graphics.Color
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .background(White, RoundedCornerShape(14.dp))
            .padding(horizontal = 14.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Chip tag
        Box(
            modifier = Modifier
                .background(chipColor, RoundedCornerShape(20.dp))
                .padding(horizontal = 10.dp, vertical = 4.dp)
        ) {
            Text(
                text = label,
                fontSize = 12.sp,
                fontWeight = FontWeight.Medium,
                color = chipTextColor
            )
        }
        Spacer(modifier = Modifier.width(10.dp))
        // Line placeholder
        Box(
            modifier = Modifier
                .height(9.dp)
                .width(80.dp)
                .clip(RoundedCornerShape(5.dp))
                .background(PurpleLight)
        )
    }
}

// UI 4 — Reminder: bell icon outline trên vòng tròn tím nhạt, chip notification
@Composable
private fun ReminderCard() {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(18.dp)
    ) {
        // Bell icon trên nền vòng tròn tím nhạt
        Box(
            modifier = Modifier
                .size(72.dp)
                .background(PurpleLight, CircleShape),
            contentAlignment = Alignment.Center
        ) {
            Icon(
                imageVector = Icons.Outlined.Notifications,
                contentDescription = null,
                tint = PurplePrimary,
                modifier = Modifier.size(36.dp)
            )
        }
        // Notification chip
        Box(
            modifier = Modifier
                .background(White, RoundedCornerShape(14.dp))
                .padding(horizontal = 18.dp, vertical = 12.dp)
        ) {
            Text(
                text = "Ôn bài Toán lúc 19:00",
                fontSize = 14.sp,
                fontWeight = FontWeight.Medium,
                color = TextPrimary
            )
        }
    }
}
