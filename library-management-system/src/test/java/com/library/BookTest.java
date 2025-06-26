package com.library;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Test class for the Book entity.
 */
public class BookTest {

    private Book book;

    @BeforeEach
    void setUp() {
        book = new Book("978-0134685991", "Effective Java", "Joshua Bloch", 2017);
    }

    @Test
    void testBookCreation() {
        assertNotNull(book);
        assertEquals("978-0134685991", book.getIsbn());
        assertEquals("Effective Java", book.getTitle());
        assertEquals("Joshua Bloch", book.getAuthor());
        assertEquals(2017, book.getYear());
    }

    @Test
    void testBookSetters() {
        book.setIsbn("978-0201633610");
        book.setTitle("Design Patterns");
        book.setAuthor("Erich Gamma");
        book.setYear(1994);

        assertEquals("978-0201633610", book.getIsbn());
        assertEquals("Design Patterns", book.getTitle());
        assertEquals("Erich Gamma", book.getAuthor());
        assertEquals(1994, book.getYear());
    }

    @Test
    void testBookEquality() {
        Book book1 = new Book("978-0134685991", "Effective Java", "Joshua Bloch", 2017);
        Book book2 = new Book("978-0134685991", "Effective Java", "Joshua Bloch", 2017);
        Book book3 = new Book("978-0201633610", "Design Patterns", "Erich Gamma", 1994);

        assertEquals(book1, book2);
        assertNotEquals(book1, book3);
        assertEquals(book1.hashCode(), book2.hashCode());
        assertNotEquals(book1.hashCode(), book3.hashCode());
    }

    @Test
    void testBookToString() {
        String expected = "Book{isbn='978-0134685991', title='Effective Java', author='Joshua Bloch', year=2017}";
        assertEquals(expected, book.toString());
    }

    @Test
    void testBookEqualityWithNull() {
        assertNotEquals(null, book);
    }

    @Test
    void testBookEqualityWithDifferentClass() {
        assertNotEquals(book, "not a book");
    }
} 