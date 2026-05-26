---
name: "performance-analyzer"
description: "Analyzes code for performance issues, identifies bottlenecks, and provides optimization recommendations. Invoke when user wants to check code performance or optimize application speed."
---

# Code Performance Analyzer

## Overview

This skill analyzes Java/Servlet code for potential performance issues and provides optimization recommendations. It helps identify bottlenecks, inefficient patterns, and suggests improvements.

## Features

- **Memory Leak Detection**: Identifies potential memory leaks in database connections and object management
- **Database Optimization**: Checks for inefficient SQL queries and connection handling
- **Concurrency Issues**: Detects thread safety problems
- **Code Smells**: Identifies performance-related anti-patterns
- **Best Practices**: Provides recommendations for performance optimization

## Performance Checks Performed

### 1. Database Connection Management
- [ ] Unclosed database connections
- [ ] Missing try-with-resources for JDBC resources
- [ ] Connection leaks in loops or exception paths

### 2. SQL Query Optimization
- [ ] Missing indexes on frequently queried columns
- [ ] SELECT * queries (fetching unnecessary columns)
- [ ] Lack of pagination for large result sets

### 3. Memory Management
- [ ] Large object instantiation in loops
- [ ] String concatenation using + operator in loops
- [ ] Unnecessary object creation

### 4. Servlet-Specific Issues
- [ ] Session attribute bloat
- [ ] Excessive request parameters processing
- [ ] Poor response handling

## Usage

### Analyzing a Single File
```
Analyze performance of: src/main/java/controller/user_controller.java
```

### Analyzing Multiple Files
```
Check performance issues in:
- src/main/java/controller/
- src/main/java/dao/
```

### Getting Recommendations
```
Provide performance optimization suggestions for my code
```

## Example Output

```
🚨 Performance Issue Detected:
File: src/main/java/dao/user_dao.java
Line: 13-25
Issue: Database connection not closed in exception path
Severity: HIGH
Recommendation: Use try-with-resources or ensure connection.close() in finally block

✅ Optimization Suggestion:
File: src/main/java/service/user_service.java
Line: 45-50
Suggestion: Consider caching frequently accessed user data
Benefit: Reduces database queries by 40%
```

## Best Practices Checklist

### Database Operations
- Use connection pooling for better resource management
- Always close connections in finally blocks or use try-with-resources
- Use prepared statements to avoid SQL injection and improve performance
- Implement pagination for large datasets

### Memory Management
- Reuse objects where possible instead of creating new ones
- Use StringBuilder for string concatenation in loops
- Avoid storing large objects in HttpSession

### Servlet Best Practices
- Minimize session data
- Use appropriate response buffering
- Implement proper error handling

## When to Invoke This Skill

1. Before deploying to production
2. When experiencing slow response times
3. After major code changes
4. During regular code reviews
5. When optimizing application performance

## Limitations

- This is a static analysis tool and may not catch runtime-specific issues
- Database-specific optimizations require knowledge of actual query execution plans
- Some recommendations may require profiling data for validation