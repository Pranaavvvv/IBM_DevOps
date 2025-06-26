package com.library;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
public class LibraryControllerTest {
    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void testAddBookAndHasBook() throws Exception {
        Book book = new Book("1234567890", "Test Book", "Test Author", 2024);
        String bookJson = objectMapper.writeValueAsString(book);

        // Add book
        mockMvc.perform(post("/books")
                .contentType(MediaType.APPLICATION_JSON)
                .content(bookJson))
                .andExpect(status().isOk())
                .andExpect(content().string("Book added successfully"));

        // Add duplicate book
        mockMvc.perform(post("/books")
                .contentType(MediaType.APPLICATION_JSON)
                .content(bookJson))
                .andExpect(status().isBadRequest())
                .andExpect(content().string("Book already exists"));

        // Check if book exists
        mockMvc.perform(get("/books/1234567890"))
                .andExpect(status().isOk())
                .andExpect(content().string("Book exists"));

        // Check for non-existent book
        mockMvc.perform(get("/books/0000000000"))
                .andExpect(status().isNotFound());
    }

    @Test
    void testGetAllBooks() throws Exception {
        // Add a book
        Book book = new Book("1111111111", "Another Book", "Author", 2023);
        String bookJson = objectMapper.writeValueAsString(book);
        mockMvc.perform(post("/books")
                .contentType(MediaType.APPLICATION_JSON)
                .content(bookJson))
                .andExpect(status().isOk());

        // Get all books
        mockMvc.perform(get("/books"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON));
    }
} 