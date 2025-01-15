"use strict";

module.exports = {
  /**
   * An asynchronous register function that runs before
   * your application is initialized.
   *
   * This gives you an opportunity to extend code.
   */
  register({ strapi }) {
    const extensionService = strapi.plugin("graphql").service("extension");

    extensionService.use(({ strapi }) => ({
      resolversConfig: {
        "Query.article": {
          middlewares: [
            async (next, parent, args, context, info) => {
              const { documentId } = args;

              // Call the next resolver (default resolver)
              const result = await next(parent, args, context, info);

              // Increment the views count
              await strapi.service("api::article.article").update(documentId, {
                data: {
                  views: (result.views || 0) + 1,
                },
              });

              // Return the updated article
              return await strapi
                .service("api::article.article")
                .findOne(documentId);
            },
          ],
        },
      },
    }));
  },
};
