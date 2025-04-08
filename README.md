# ShiftCare Client Manager

A command-line Ruby application for managing client data. This tool allows users to search clients by full_name and find duplicate email addresses within a JSON dataset.

## Features

- **Search by Name**: Find clients whose names match a search query (case insensitive, partial matching)
- **Find Duplicate Emails**: Identify clients that share the same email address

## Requirements

- Ruby 2.6+
- Bundler

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/crisnahine/ShiftCare-Technical-Challenge
   cd ShiftCare-Technical-Challenge
   ```

2. Install dependencies:
   ```
   bundle install
   ```

3. Make the client manager executable:
   ```
   chmod +x bin/client_manager
   ```

## Usage

### Basic Usage

```
bin/client_manager [options] [command] [arguments]
```

### Available Commands

#### Search

Search for clients by full_name:

```
bin/client_manager search <query>
```

Example:
```
bin/client_manager search Smith
```

#### Find Duplicates

Find clients with duplicate email addresses:

```
bin/client_manager duplicates
```

### Options

- `-f, --file FILE`: Specify JSON file path (default: ./clients.json)
- `-h, --help`: Show help message
- `-v, --version`: Show version

## Testing

Run the test suite:

```
bundle exec rspec
```

Generate code coverage report:

```
bundle exec rspec
open coverage/index.html  # View coverage report
```

## Project Structure

```
├── bin/                  # Executable scripts
├── lib/                  # Application code
│   ├── shift_care/       # Core functionality
│   │   ├── commands/     # Command implementations
│   │   └── ...
│   └── shift_care.rb     # Main entry point
└── spec/                 # Tests
    ├── fixtures/         # Test data
    └── lib/              # Test implementations
```

## Design Decisions & Assumptions

### Architecture

- **Command Pattern**: The application uses the Command pattern to encapsulate and decouple command logic.
- **Repository Pattern**: Client data access is abstracted through a repository, making it easier to change data sources.

### Assumptions

- The JSON data is well-formed and follows the expected structure with `id`, `full_name`, and `email` fields.
- Email addresses should be case-insensitive for duplicate detection.
- Search by full_name is partial and case-insensitive for better user experience.

## Limitations & Future Improvements

### Current Limitations

- Only supports JSON files as data sources
- Limited to pre-defined search fields (full_name and email)
- All data is loaded into memory, which could be problematic for very large datasets

### Future Improvements

#### Short-term

- Add support for filtering by other client fields
- Implement more sophisticated search algorithms (e.g., fuzzy searching)
- Add export functionality for search results

#### Medium-term

- Create a web interface using Sinatra or Rails
- Add data persistence with a database
- Support for CSV and other data formats

#### Long-term

- RESTful API for client data access
- Authentication and authorization
- Real-time notifications for duplicate detection
- Implement caching mechanisms for scaling and improved performance

## API Expansion (Next Steps)

### Dynamic Field Searching

To allow searching on any field:

```ruby
# Enhance ClientRepository with dynamic field search
def search_by_field(field, query)
  @clients.select do |client|
    value = client.to_h[field.to_sym]
    value.to_s.downcase.include?(query.to_s.downcase)
  end
end
```

### REST API Implementation

Using Sinatra:

```ruby
# app.rb
require 'sinatra'
require_relative 'lib/shift_care'

repository = ShiftCare::ClientRepository.new('clients.json')

get '/clients/search' do
  field = params[:field] || 'full_name'
  query = params[:q]
  content_type :json

  if query
    repository.search_by_field(field, query).map(&:to_h).to_json
  else
    { error: "Query parameter 'q' is required" }.to_json
  end
end

get '/clients/duplicates' do
  content_type :json
  repository.find_duplicates_by_email.transform_values { |clients| clients.map(&:to_h) }.to_json
end
```

### Scaling Considerations

- Implement pagination for large result sets
- Use database indexes for faster searches
- Add caching layer (Redis/Memcached) for frequently accessed data
- Consider async processing for intensive operations
- Implement rate limiting for API endpoints