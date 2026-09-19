impl Dispatch<zcosmic_toplevel_handle_v1::ZcosmicToplevelHandleV1, ()> for AppData {
    fn event(
        app_data: &mut Self,
        handle: &zcosmic_toplevel_handle_v1::ZcosmicToplevelHandleV1,
        event: zcosmic_toplevel_handle_v1::Event,
        _: &(),
        _: &Connection,
        _: &QueueHandle<Self>,
    ) {
        let Some(index) = app_data
            .by_cosmic_id
            .get(&handle.id().protocol_id())
            .copied()
        else {
            return;
        };

        let record = &mut app_data.records[index];
        match event {
            zcosmic_toplevel_handle_v1::Event::State { state } => {
                record.focused = false;
                record.hidden = false;

                let (chunks, _) = state.as_chunks::<4>();
                for value in chunks {
                    if let Ok(parsed) = zcosmic_toplevel_handle_v1::State::try_from(
                        u32::from_ne_bytes(*value),
                    ) {
                        if parsed == zcosmic_toplevel_handle_v1::State::Activated {
                            record.focused = true;
                        }
                        if parsed == zcosmic_toplevel_handle_v1::State::Minimized {
                            record.hidden = true;
                        }
                    }
                }
            }
            zcosmic_toplevel_handle_v1::Event::Geometry { .. }
            | zcosmic_toplevel_handle_v1::Event::OutputEnter { .. }
            | zcosmic_toplevel_handle_v1::Event::OutputLeave { .. }
            | zcosmic_toplevel_handle_v1::Event::WorkspaceEnter { .. }
            | zcosmic_toplevel_handle_v1::Event::WorkspaceLeave { .. }
            | zcosmic_toplevel_handle_v1::Event::ExtWorkspaceEnter { .. }
            | zcosmic_toplevel_handle_v1::Event::ExtWorkspaceLeave { .. }
            | zcosmic_toplevel_handle_v1::Event::Title { .. }
            | zcosmic_toplevel_handle_v1::Event::AppId { .. }
            | zcosmic_toplevel_handle_v1::Event::Done
            | zcosmic_toplevel_handle_v1::Event::Closed => {}
            _ => unreachable!(),
        }
    }
}

impl Dispatch<zcosmic_toplevel_manager_v1::ZcosmicToplevelManagerV1, ()> for AppData {
    fn event(
        app_data: &mut Self,
        _manager: &zcosmic_toplevel_manager_v1::ZcosmicToplevelManagerV1,
        event: zcosmic_toplevel_manager_v1::Event,
        _: &(),
        _: &Connection,
        _: &QueueHandle<Self>,
    ) {
        match event {
            zcosmic_toplevel_manager_v1::Event::Capabilities { capabilities } => {
                let (chunks, _) = capabilities.as_chunks::<4>();
                app_data.capabilities = chunks
                    .iter()
                    .map(|chunk| WEnum::from(u32::from_ne_bytes(**chunk)))
                    .collect();
            }
            _ => unreachable!(),
        }
    }
}
