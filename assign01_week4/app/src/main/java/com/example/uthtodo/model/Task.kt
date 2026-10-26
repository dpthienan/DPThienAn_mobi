package com.example.uthtodo.model

/**
 * Công việc Todo — dữ liệu hiển thị trên Home dùng class này.
 */
data class Task(
    val id: Int,
    val title: String,
    val category: TaskCategory,
    val dueTime: String? = null,
    val isCompleted: Boolean = false
) {
    fun markDone(): Task = copy(isCompleted = true)

    fun toggle(): Task = copy(isCompleted = !isCompleted)
}
