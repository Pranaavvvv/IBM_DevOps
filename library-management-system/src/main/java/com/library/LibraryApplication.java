package com.library;

import com.codahale.metrics.MetricRegistry;
import com.codahale.metrics.graphite.Graphite;
import com.codahale.metrics.graphite.GraphiteReporter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.net.InetSocketAddress;
import java.util.concurrent.TimeUnit;

/**
 * Main application class for the Library Management System.
 * Demonstrates the library functionality and sets up metrics reporting.
 */
public class LibraryApplication {
    private static final Logger logger = LoggerFactory.getLogger(LibraryApplication.class);

    public static void main(String[] args) {
        logger.info("Starting Library Management System...");

        // Initialize metrics
        MetricRegistry metrics = new MetricRegistry();
        
        // Setup Graphite reporter (commented out for local development)
        // setupGraphiteReporter(metrics);

        // Create library instance
        Library library = new Library(metrics);

        // Demo the library functionality
        demonstrateLibrary(library);

        logger.info("Library Management System demo completed.");
        logger.info("Total books in library: {}", library.getTotalBooks());
    }

    /**
     * Sets up Graphite reporter for metrics (uncomment when Graphite is available).
     */
    private static void setupGraphiteReporter(MetricRegistry metrics) {
        try {
            Graphite graphite = new Graphite(new InetSocketAddress("localhost", 2003));
            GraphiteReporter reporter = GraphiteReporter.forRegistry(metrics)
                    .prefixedWith("library.system")
                    .build(graphite);
            
            reporter.start(10, TimeUnit.SECONDS);
            logger.info("Graphite reporter started");
        } catch (Exception e) {
            logger.warn("Failed to setup Graphite reporter: {}", e.getMessage());
        }
    }

    /**
     * Demonstrates the library functionality with sample books.
     */
    private static void demonstrateLibrary(Library library) {
        logger.info("=== Library Management System Demo ===");

        // Add some sample books
        Book book1 = new Book("978-0134685991", "Effective Java", "Joshua Bloch", 2017);
        Book book2 = new Book("978-0201633610", "Design Patterns", "Erich Gamma", 1994);
        Book book3 = new Book("978-0596009205", "Head First Java", "Kathy Sierra", 2005);

        logger.info("Adding books to library...");
        library.addBook(book1);
        library.addBook(book2);
        library.addBook(book3);

        // Try to add a duplicate book
        Book duplicateBook = new Book("978-0134685991", "Effective Java", "Joshua Bloch", 2017);
        library.addBook(duplicateBook);

        // Search for books
        logger.info("Searching for books...");
        logger.info("Has book with ISBN 978-0134685991: {}", library.hasBook("978-0134685991"));
        logger.info("Has book with ISBN 978-0201633610: {}", library.hasBook("978-0201633610"));
        logger.info("Has book with ISBN 999-9999999999: {}", library.hasBook("999-9999999999"));

        // Display all books
        logger.info("All books in library:");
        library.getAllBooks().forEach(book -> 
            logger.info("  - {} by {} ({})", book.getTitle(), book.getAuthor(), book.getIsbn())
        );
    }
} 