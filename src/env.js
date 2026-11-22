import { defineEnvVars } from '@sveltejs/kit/env';

export const variables = defineEnvVars({
    PRIVATE_SUPABASE_ANON_KEY: {},
    PRIVATE_SUPABASE_SERVICE_KEY: {},
    PRIVATE_SUPABASE_URL: {},
    PUBLIC_LIVECHAT_URL: {
		public: true
    }
});
