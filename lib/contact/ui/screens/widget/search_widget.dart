import 'package:flutter/material.dart';

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        query = '';
      },
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Center(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    List<String> suggestion = ['brazil', 'China', 'USA', 'India'];
    return ListView.builder(
      itemCount: suggestion.length,
      itemBuilder: (context, index) {
        final suggestio = suggestion[index];

        return ListTile(
          title: Text(suggestio),
          onTap: () {
            query = suggestio;
            showResults(context);
          },
        );
      },
    );
  }
}
