SwiftApp.service('FlickrService', ['$http', function($http) {

    return {
        getById: function(id) {
            return $http.get('/flickr/get_by_id/' + id);
        }
    };

}]);
