import rest from 'rest';
import mime from 'rest/interceptor/mime';
import timeout from 'rest/interceptor/timeout';
import errorCode from 'rest/interceptor/errorCode';

const client = rest.wrap(timeout, {timeout: 5000}).wrap(mime).wrap(errorCode);

export default function (endpoint) {
  return client({
    path: endpoint
  }).then(function (response) {
    return response.entity;
  });
};
