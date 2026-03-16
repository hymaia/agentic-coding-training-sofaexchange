package com.sofaexchange

import org.junit.Assert.assertTrue
import org.junit.Test

class HelloWorldTest {

    @Test
    fun `returns true`() {
        fun helloWorld(): Boolean = true
        assertTrue(helloWorld())
    }
}
