SwiftApp.service('InstagramService', ['$http', function($http) {

    return {
        getByTag: function(tag) {
            return $http.get('/instagram/get_by_tag/' + tag);
        }
    }

}]);
