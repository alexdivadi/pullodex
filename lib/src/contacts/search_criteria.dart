enum SearchCriteria {
  firstName,
  lastName,
}

extension SearchCriteriaExtension on SearchCriteria {
  String get name {
    switch (this) {
      case SearchCriteria.firstName:
        return 'First Name';
      case SearchCriteria.lastName:
        return 'Last Name';
    }
  }
}
