package com.example.uthtodo.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Checklist
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.uthtodo.ui.theme.PurplePrimary
import com.example.uthtodo.ui.theme.TextPrimary
import com.example.uthtodo.ui.theme.White

@Composable
fun AppLogoHeader(
    appName: String,
    onSkip: (() -> Unit)? = null,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = 8.dp, vertical = 4.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            Box(
                modifier = Modifier
                    .size(36.dp)
                    .background(PurplePrimary, RoundedCornerShape(10.dp)),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Outlined.Checklist,
                    contentDescription = null,
                    tint = White,
                    modifier = Modifier.size(22.dp)
                )
            }
            // "UTH" regular dark + "Todo" bold purple — matches design
            Text(
                text = buildAnnotatedString {
                    withStyle(
                        style = SpanStyle(
                            color = TextPrimary,
                            fontSize = 18.sp,
                            fontWeight = FontWeight.Normal
                        )
                    ) { append("UTH ") }
                    withStyle(
                        style = SpanStyle(
                            color = PurplePrimary,
                            fontSize = 18.sp,
                            fontWeight = FontWeight.Bold
                        )
                    ) { append("Todo") }
                }
            )
        }
        if (onSkip != null) {
            TextButton(onClick = onSkip) {
                Text(
                    text = "Bỏ qua",
                    color = TextPrimary,
                    fontSize = 15.sp,
                    fontWeight = FontWeight.Normal
                )
            }
        }
    }
}
