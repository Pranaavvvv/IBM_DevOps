package com.library;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import javax.annotation.PostConstruct;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@RestController
@RequestMapping("/books")
public class LibraryController {
    private Library library;

    @PostConstruct
    public void init() {
        // Use a simple in-memory metrics registry for now
        library = new Library(new com.codahale.metrics.MetricRegistry());
    }

    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<String> addBook(@RequestBody Book book) {
        boolean added = library.addBook(book);
        if (added) {
            return ResponseEntity.ok("Book added successfully");
        } else {
            return ResponseEntity.badRequest().body("Book already exists");
        }
    }

    @GetMapping(value = "/{isbn}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> hasBook(@PathVariable String isbn) {
        boolean exists = library.hasBook(isbn);
        if (exists) {
            return ResponseEntity.ok("Book exists");
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public Set<Book> getAllBooks() {
        return library.getAllBooks();
    }
} 