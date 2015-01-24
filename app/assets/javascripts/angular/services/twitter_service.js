SwiftApp.service('TwitterService', ['$http', function($http) {

    return {
        getByTag: function(tag) {
            return $http.get('/twitter/get_by_tag/' + tag);
        }
    }

}]);
