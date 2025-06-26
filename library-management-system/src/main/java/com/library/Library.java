package com.library;

import com.codahale.metrics.Counter;
import com.codahale.metrics.MetricRegistry;
import com.codahale.metrics.Timer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashSet;
import java.util.Set;

/**
 * Main library management system class.
 */
public class Library {
    private static final Logger logger = LoggerFactory.getLogger(Library.class);
    
    private final Set<Book> books;
    private final MetricRegistry metrics;
    private final Counter booksAddedCounter;
    private final Counter booksSearchedCounter;
    private final Timer addBookTimer;
    private final Timer searchBookTimer;

    public Library(MetricRegistry metrics) {
        this.books = new HashSet<>();
        this.metrics = metrics;
        
        // Initialize metrics
        this.booksAddedCounter = metrics.counter("library.books.added");
        this.booksSearchedCounter = metrics.counter("library.books.searched");
        this.addBookTimer = metrics.timer("library.addbook.duration");
        this.searchBookTimer = metrics.timer("library.searchbook.duration");
        
        logger.info("Library initialized with metrics collection enabled");
    }

    /**
     * Adds a book to the library.
     * @param book The book to add
     * @return true if the book was added successfully, false if it already exists
     */
    public boolean addBook(Book book) {
        if (book == null) {
            logger.warn("Attempted to add null book");
            return false;
        }

        Timer.Context context = addBookTimer.time();
        try {
            boolean added = books.add(book);
            if (added) {
                booksAddedCounter.inc();
                logger.info("Book added successfully: {}", book.getTitle());
            } else {
                logger.info("Book already exists: {}", book.getTitle());
            }
            return added;
        } finally {
            context.stop();
        }
    }

    /**
     * Checks if a book exists in the library by ISBN.
     * @param isbn The ISBN to search for
     * @return true if the book exists, false otherwise
     */
    public boolean hasBook(String isbn) {
        if (isbn == null || isbn.trim().isEmpty()) {
            logger.warn("Attempted to search with null or empty ISBN");
            return false;
        }

        Timer.Context context = searchBookTimer.time();
        try {
            booksSearchedCounter.inc();
            boolean found = books.stream()
                    .anyMatch(book -> book.getIsbn().equals(isbn));
            
            logger.info("Book search for ISBN {}: {}", isbn, found ? "FOUND" : "NOT FOUND");
            return found;
        } finally {
            context.stop();
        }
    }

    /**
     * Gets the total number of books in the library.
     * @return The number of books
     */
    public int getTotalBooks() {
        return books.size();
    }

    /**
     * Gets all books in the library.
     * @return A copy of the books set
     */
    public Set<Book> getAllBooks() {
        return new HashSet<>(books);
    }

    /**
     * Gets the metrics registry for monitoring.
     * @return The metric registry
     */
    public MetricRegistry getMetrics() {
        return metrics;
    }
} 