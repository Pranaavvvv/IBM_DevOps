package com.library;

import com.codahale.metrics.MetricRegistry;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Test class for the Library management system.
 */
public class LibraryTest {

    private Library library;
    private MetricRegistry metrics;

    @BeforeEach
    void setUp() {
        metrics = new MetricRegistry();
        library = new Library(metrics);
    }

    @Test
    void testAddBook() {
        Book book = new Book("978-0134685991", "Effective Java", "Joshua Bloch", 2017);
        
        assertTrue(library.addBook(book));
        assertEquals(1, library.getTotalBooks());
    }

    @Test
    void testAddDuplicateBook() {
        Book book1 = new Book("978-0134685991", "Effective Java", "Joshua Bloch", 2017);
        Book book2 = new Book("978-0134685991", "Effective Java", "Joshua Bloch", 2017);
        
        assertTrue(library.addBook(book1));
        assertFalse(library.addBook(book2)); // Should not add duplicate
        assertEquals(1, library.getTotalBooks());
    }

    @Test
    void testAddNullBook() {
        assertFalse(library.addBook(null));
        assertEquals(0, library.getTotalBooks());
    }

    @Test
    void testHasBook() {
        Book book = new Book("978-0134685991", "Effective Java", "Joshua Bloch", 2017);
        library.addBook(book);
        
        assertTrue(library.hasBook("978-0134685991"));
        assertFalse(library.hasBook("978-0201633610"));
    }

    @Test
    void testHasBookWithNullIsbn() {
        assertFalse(library.hasBook(null));
    }

    @Test
    void testHasBookWithEmptyIsbn() {
        assertFalse(library.hasBook(""));
        assertFalse(library.hasBook("   "));
    }

    @Test
    void testGetAllBooks() {
        Book book1 = new Book("978-0134685991", "Effective Java", "Joshua Bloch", 2017);
        Book book2 = new Book("978-0201633610", "Design Patterns", "Erich Gamma", 1994);
        
        library.addBook(book1);
        library.addBook(book2);
        
        assertEquals(2, library.getAllBooks().size());
        assertTrue(library.getAllBooks().contains(book1));
        assertTrue(library.getAllBooks().contains(book2));
    }

    @Test
    void testGetAllBooksReturnsCopy() {
        Book book = new Book("978-0134685991", "Effective Java", "Joshua Bloch", 2017);
        library.addBook(book);
        
        var books = library.getAllBooks();
        books.clear(); // This should not affect the original library
        
        assertEquals(1, library.getTotalBooks());
    }

    @Test
    void testGetTotalBooks() {
        assertEquals(0, library.getTotalBooks());
        
        Book book1 = new Book("978-0134685991", "Effective Java", "Joshua Bloch", 2017);
        Book book2 = new Book("978-0201633610", "Design Patterns", "Erich Gamma", 1994);
        
        library.addBook(book1);
        assertEquals(1, library.getTotalBooks());
        
        library.addBook(book2);
        assertEquals(2, library.getTotalBooks());
    }

    @Test
    void testMetricsCollection() {
        Book book = new Book("978-0134685991", "Effective Java", "Joshua Bloch", 2017);
        
        // Test adding book
        library.addBook(book);
        assertEquals(1, metrics.counter("library.books.added").getCount());
        
        // Test searching book
        library.hasBook("978-0134685991");
        assertEquals(1, metrics.counter("library.books.searched").getCount());
        
        // Test timers exist
        assertNotNull(metrics.timer("library.addbook.duration"));
        assertNotNull(metrics.timer("library.searchbook.duration"));
    }

    @Test
    void testMultipleBooks() {
        Book book1 = new Book("978-0134685991", "Effective Java", "Joshua Bloch", 2017);
        Book book2 = new Book("978-0201633610", "Design Patterns", "Erich Gamma", 1994);
        Book book3 = new Book("978-0596009205", "Head First Java", "Kathy Sierra", 2005);
        
        library.addBook(book1);
        library.addBook(book2);
        library.addBook(book3);
        
        assertEquals(3, library.getTotalBooks());
        assertTrue(library.hasBook("978-0134685991"));
        assertTrue(library.hasBook("978-0201633610"));
        assertTrue(library.hasBook("978-0596009205"));
        assertFalse(library.hasBook("999-9999999999"));
    }
} 