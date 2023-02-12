export const get = async () => {
    const links = [
        'https://cdn.discordapp.com/attachments/1074403508901650512/1074404326912573571/fabric-api-0.72.01.19.2.jar',
        'https://cdn.discordapp.com/attachments/1074403508901650512/1074404373251231845/sodium-fabric-mc1.19.2-0.4.4build.18.jar',
    ]

    const file_names = links.map( link => link.split('/').pop() )

    const names_links = links.map( (link, i) => [file_names[i], link] )

	return {
		body: {
			'mods': names_links
		}
	}
}
